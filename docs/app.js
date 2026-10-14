// Camera movement and drawing. The Worker turns a pose into one Logfire query and returns 200 hex scanlines.
const EYE = 41;
const pose = { x: 370.85, y: 284.19, z: null, angle: 0 };
const ctx = document.getElementById("screen").getContext("2d");
const status = document.getElementById("status");
let busy = false, frames = 0;

function moved(key, run) {
  const p = { ...pose }, step = run ? 48 : 24, turn = run ? 22.5 : 11.25, a = (p.angle * Math.PI) / 180;
  if (key === "w" || key === "ArrowUp") { p.x += step * Math.cos(a); p.y += step * Math.sin(a); }
  else if (key === "s" || key === "ArrowDown") { p.x -= step * Math.cos(a); p.y -= step * Math.sin(a); }
  else if (key === "a") { p.x -= step * Math.sin(a); p.y += step * Math.cos(a); }
  else if (key === "d") { p.x += step * Math.sin(a); p.y -= step * Math.cos(a); }
  else if (key === "q" || key === "ArrowLeft") p.angle = (p.angle + turn) % 360;
  else if (key === "e" || key === "ArrowRight") p.angle = (p.angle - turn + 360) % 360;
  return p;
}

function draw(lines) {
  const img = ctx.createImageData(320, 200);
  for (let y = 0; y < 200; y++) {
    const line = lines[y];
    for (let x = 0; x < 320; x++) {
      const v = parseInt(line.substr(x * 6, 6), 16), i = (y * 320 + x) * 4;
      img.data[i] = v >> 16; img.data[i + 1] = (v >> 8) & 255; img.data[i + 2] = v & 255; img.data[i + 3] = 255;
    }
  }
  ctx.putImageData(img, 0, 0);
}

async function go(key, run) {
  if (busy) return;
  busy = true; document.body.classList.add("busy");
  const p = moved(key, run);
  const q = new URLSearchParams({ x: p.x, y: p.y, angle: p.angle });
  if (p.z !== null) q.set("z", p.z);
  try {
    const r = await fetch(`${window.DOOM_WORKER}/frame?${q}`);
    const body = await r.json();
    if (!r.ok) throw new Error(body.error || r.status);
    draw(body.lines);
    Object.assign(pose, p);
    if (body.floor !== null) pose.z = body.floor + EYE;
    frames++;
    status.textContent = `frame ${frames}: ${body.seconds.toFixed(2)} s on Logfire` +
      (body.queries > 1 ? ` (${body.queries} queries)` : "") +
      ` · x ${pose.x.toFixed(0)} y ${pose.y.toFixed(0)} angle ${pose.angle.toFixed(0)}`;
  } catch (e) {
    status.textContent = `error: ${e.message}`;
  } finally {
    busy = false; document.body.classList.remove("busy");
  }
}

addEventListener("keydown", (e) => {
  const k = e.key.length === 1 ? e.key.toLowerCase() : e.key;
  if (["w", "a", "s", "d", "q", "e", "ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(k)) {
    e.preventDefault(); go(k, e.shiftKey);
  }
});
document.querySelectorAll("#pad button").forEach((b) => b.addEventListener("click", () => go(b.dataset.k, false)));
go("", false);
