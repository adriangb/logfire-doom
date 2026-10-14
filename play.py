"""Doom on Logfire: every frame is one POST /v2/query. Movement is the only thing done here.

    DOOM_READ_TOKEN=... DOOM_SERVICE=doom-xxxxxx uv run --with httpx --with pillow play.py
    DOOM_LOCAL=1 uv run --with datafusion --with pillow play.py       # no Logfire: local DataFusion on packed/

Then open http://localhost:8666. W/S or arrows move, A/D strafe, Q/E or left/right turn, Shift runs.
"""
import io, json, math, os, time
from datetime import datetime, timedelta, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from PIL import Image
import port

HERE = Path(__file__).parent
if (HERE / ".env").exists():  # KEY=value lines; the environment wins
    for line in (HERE / ".env").read_text().splitlines():
        k, sep, v = line.partition("=")
        if sep and not k.startswith("#"):
            os.environ.setdefault(k.strip(), v.strip())
URL = os.environ.get("DOOM_LOGFIRE_URL", "https://logfire-us.pydantic.dev")
LOCAL = os.environ.get("DOOM_LOCAL") == "1"
SVC = os.environ.get("DOOM_SERVICE", "")
EYE = 41.0
# Where the player stands in the snapshot of E1M1 that the tables hold; z comes from the first frame.
pose = {"x": float(os.environ.get("DOOM_X", 370.85)), "y": float(os.environ.get("DOOM_Y", 284.19)), "z": None,
        "angle": float(os.environ.get("DOOM_ANGLE", 0))}
PLAYER = int(os.environ.get("DOOM_PLAYER", 157))

if LOCAL:
    from datafusion import SessionContext
    ctx = SessionContext()
    for f in sorted((HERE / "packed").glob("*.parquet")):
        ctx.register_parquet(f.stem, str(f))
    TEMPLATE = (HERE / "frame_local.sql").read_text()
else:
    import httpx
    client = httpx.Client(timeout=300)
    TEMPLATE = (HERE / "frame_ff.sql").read_text().replace("${svc}", SVC)
    MIN_TS = (datetime.now(timezone.utc) - timedelta(days=int(os.environ.get("DOOM_LOOKBACK_DAYS", 7)))).isoformat()

def query(sql):
    if LOCAL:
        return ctx.sql(sql).to_arrow_table().to_pylist()
    r = client.post(f"{URL}/v2/query", json={"sql": sql, "min_timestamp": MIN_TS, "limit": 1000},
                    headers={"Authorization": f"Bearer {os.environ['DOOM_READ_TOKEN']}", "Accept": "application/json"})
    if r.status_code != 200:
        raise RuntimeError(f"{r.status_code}: {r.text[:2000]}")
    body = r.json()
    if body.get("error"):
        raise RuntimeError(body["error"])
    return body["data"]

def frame():
    """Render at the current pose; follow the floor; return (png bytes, stats)."""
    z = pose["z"] if pose["z"] is not None else 0.0
    sql = port.fold(TEMPLATE, (pose["x"], pose["y"], z, pose["angle"]), player=PLAYER)
    t0 = time.time(); rows = query(sql); dt = time.time() - t0
    floor = next((r["line"] for r in rows if r["y"] == -1), None)
    first = pose["z"] is None
    if floor is not None:
        pose["z"] = float(floor) + EYE
    if first and floor is not None:
        return frame()  # the first query only found the floor
    lines = [r["line"] for r in sorted(rows, key=lambda r: r["y"]) if r["y"] >= 0]
    if len(lines) != 200:
        raise RuntimeError(f"{len(lines)} scanlines, not 200")
    img = Image.frombytes("RGB", (320, 200), bytes.fromhex("".join(lines)))
    buf = io.BytesIO(); img.save(buf, "PNG")
    return buf.getvalue(), {"seconds": round(dt, 2), "sql_bytes": len(sql), **pose}

def move(key, run):
    step, turn = (48 if run else 24), (22.5 if run else 11.25)
    a = math.radians(pose["angle"])
    if key in ("w", "ArrowUp"): pose["x"] += step * math.cos(a); pose["y"] += step * math.sin(a)
    elif key in ("s", "ArrowDown"): pose["x"] -= step * math.cos(a); pose["y"] -= step * math.sin(a)
    elif key == "a": pose["x"] -= step * math.sin(a); pose["y"] += step * math.cos(a)
    elif key == "d": pose["x"] += step * math.sin(a); pose["y"] -= step * math.cos(a)
    elif key in ("q", "ArrowLeft"): pose["angle"] = (pose["angle"] + turn) % 360
    elif key in ("e", "ArrowRight"): pose["angle"] = (pose["angle"] - turn) % 360

PAGE = """<!doctype html><meta charset=utf-8><title>Doom on Logfire</title>
<style>body{background:#111;color:#ccc;font:14px ui-monospace,monospace;text-align:center}
img{width:960px;max-width:100%;image-rendering:pixelated;border:1px solid #333}#s{margin:8px}.busy img{opacity:.6}</style>
<h3>Doom on Logfire: one POST /v2/query per frame</h3><img id=f><div id=s>rendering the first frame</div>
<div>W/S move, A/D strafe, Q/E or arrows turn, Shift runs</div>
<script>
let busy=false, n=0;
async function go(key, run){ if(busy) return; busy=true; document.body.className='busy';
  try{ const r=await fetch('/frame?key='+encodeURIComponent(key||'')+'&run='+(run?1:0));
    if(!r.ok){ s.textContent=await r.text(); } else { const st=JSON.parse(r.headers.get('X-Stats'));
      f.src=URL.createObjectURL(await r.blob()); n++;
      s.textContent=`frame ${n}: ${st.seconds}s for a ${(st.sql_bytes/1024).toFixed(0)} KB query; x=${st.x.toFixed(0)} y=${st.y.toFixed(0)} z=${st.z.toFixed(0)} angle=${st.angle.toFixed(0)}`; } }
  finally{ busy=false; document.body.className=''; } }
addEventListener('keydown', e=>{ const k=e.key.length==1?e.key.toLowerCase():e.key;
  if(['w','a','s','d','q','e','ArrowUp','ArrowDown','ArrowLeft','ArrowRight'].includes(k)){ e.preventDefault(); go(k, e.shiftKey); } });
go('');
</script>"""

class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def do_GET(self):
        if self.path == "/":
            body = PAGE.encode(); self.send_response(200); self.send_header("Content-Type", "text/html")
            self.send_header("Content-Length", str(len(body))); self.end_headers(); self.wfile.write(body); return
        if self.path.startswith("/frame"):
            from urllib.parse import urlparse, parse_qs
            q = parse_qs(urlparse(self.path).query)
            before = dict(pose)
            try:
                move(q.get("key", [""])[0], q.get("run", ["0"])[0] == "1")
                png, stats = frame()
            except Exception as e:
                pose.update(before)
                body = str(e).encode(); self.send_response(500); self.send_header("Content-Length", str(len(body)))
                self.end_headers(); self.wfile.write(body); return
            print(stats, flush=True)
            self.send_response(200); self.send_header("Content-Type", "image/png")
            self.send_header("X-Stats", json.dumps(stats)); self.send_header("Content-Length", str(len(png)))
            self.end_headers(); self.wfile.write(png); return
        self.send_response(404); self.end_headers()

if __name__ == "__main__":
    port_no = int(os.environ.get("PORT", 8666))
    print(f"http://localhost:{port_no}  ({'local DataFusion' if LOCAL else URL + ' service ' + SVC})")
    ThreadingHTTPServer(("127.0.0.1", port_no), Handler).serve_forever()
