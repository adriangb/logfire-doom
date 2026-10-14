// Logfire Doom proxy: takes a camera pose, renders one frame with POST /v2/query, returns the scanlines.
// The read token stays here, and visitors can only choose the pose, not the SQL.
import TEMPLATE from "./frame.sql";

const EYE = 41;
// E1M1's extent with a margin; a pose outside it is refused.
const BOUNDS = { x: [-1000, 4500], y: [-5500, 1500], z: [-500, 500] };

function cors(env, origin) {
  const allowed = env.ALLOWED_ORIGIN === "*" || origin === env.ALLOWED_ORIGIN;
  return {
    "Access-Control-Allow-Origin": allowed ? origin || "*" : env.ALLOWED_ORIGIN,
    "Access-Control-Allow-Methods": "GET, OPTIONS",
    Vary: "Origin",
  };
}

function json(body, status, headers) {
  return new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json", ...headers } });
}

function num(params, name, required) {
  const raw = params.get(name);
  if (raw === null || raw === "") {
    if (required) throw new Error(`missing ${name}`);
    return null;
  }
  const v = Number(raw);
  if (!Number.isFinite(v)) throw new Error(`bad ${name}`);
  return v;
}

function sql(env, x, y, z, angle) {
  // String(Number) is always a valid SQL numeric literal ("-87", "370.85", "1e-7").
  return TEMPLATE.replaceAll("${svc}", env.DOOM_SERVICE)
    .replaceAll("${px}", String(x)).replaceAll("${py}", String(y))
    .replaceAll("${pz}", String(z)).replaceAll("${angle}", String(angle));
}

async function query(env, text) {
  const minTs = new Date(Date.now() - Number(env.LOOKBACK_DAYS) * 86400e3).toISOString();
  const r = await fetch(`${env.LOGFIRE_URL}/v2/query`, {
    method: "POST",
    headers: { Authorization: `Bearer ${env.DOOM_READ_TOKEN}`, Accept: "application/json", "Content-Type": "application/json" },
    body: JSON.stringify({ sql: text, min_timestamp: minTs, limit: 1000 }),
  });
  const body = await r.json().catch(() => ({ error: `HTTP ${r.status}` }));
  if (!r.ok || body.error) throw new Error(`Logfire: ${body.error || r.status}`);
  return body.data;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const headers = cors(env, request.headers.get("Origin"));
    if (request.method === "OPTIONS") return new Response(null, { status: 204, headers });
    if (url.pathname !== "/frame" || request.method !== "GET") return json({ error: "not found" }, 404, headers);

    const ip = request.headers.get("CF-Connecting-IP") || "local";
    if (env.LIMITER) {
      const { success } = await env.LIMITER.limit({ key: ip });
      if (!success) return json({ error: "too many frames, slow down" }, 429, headers);
    }

    let x, y, z, angle;
    try {
      x = num(url.searchParams, "x", true);
      y = num(url.searchParams, "y", true);
      z = num(url.searchParams, "z", false);
      angle = ((num(url.searchParams, "angle", true) % 360) + 360) % 360;
      for (const [k, v] of [["x", x], ["y", y], ["z", z]]) {
        if (v !== null && (v < BOUNDS[k][0] || v > BOUNDS[k][1])) throw new Error(`${k} out of bounds`);
      }
    } catch (e) {
      return json({ error: e.message }, 400, headers);
    }

    try {
      const t0 = Date.now();
      let rows = await query(env, sql(env, x, y, z ?? 0, angle));
      let queries = 1;
      const floorOf = (rs) => { const r = rs.find((r) => r.y === -1); return r && r.line !== null ? Number(r.line) : null; };
      // Without a z, the first query only finds the floor; render again at eye height.
      if (z === null && floorOf(rows) !== null) {
        rows = await query(env, sql(env, x, y, floorOf(rows) + EYE, angle));
        queries = 2;
      }
      const lines = rows.filter((r) => r.y >= 0).sort((a, b) => a.y - b.y).map((r) => r.line);
      if (lines.length !== 200) throw new Error(`${lines.length} scanlines, not 200`);
      return json({ lines, floor: floorOf(rows), queries, seconds: (Date.now() - t0) / 1000 }, 200, headers);
    } catch (e) {
      return json({ error: e.message }, 502, headers);
    }
  },
};
