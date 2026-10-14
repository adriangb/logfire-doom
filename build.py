"""Build the frame query: table prelude (from Logfire records) + ported renderer + scanline output."""
import re, sys
from pathlib import Path
import pyarrow as pa, pyarrow.parquet as pq

TYPES = [(pa.types.is_boolean, "BOOLEAN"), (pa.types.is_int64, "BIGINT"), (pa.types.is_integer, "INT"),
         (pa.types.is_float32, "FLOAT"), (pa.types.is_floating, "DOUBLE")]
TEXEL = "NULLIF(ascii(substr(tx.s, CAST(f.tkey & 255 AS INT) + 1, 1)) - 256, -210)"

def prelude(packed, svc="${svc}"):
    ctes = []
    for f in sorted(Path(packed).glob("*.parquet")):
        cols = []
        for fld in pq.read_schema(f):
            e = f"attributes->>'{fld.name}'"
            ty = next((n for p, n in TYPES if p(fld.type)), None)
            # Every number is read as DOUBLE first. The same attribute key (x, y, id, ...) is an integer
            # in one table and a float in another, and Logfire evaluated CAST(attributes->>'x' AS INT)
            # on rows that the span_name filter excludes ("Cannot cast string '22.0' to Int32").
            if ty in ("INT", "BIGINT", "FLOAT", "DOUBLE"):
                cols.append(f'CAST(CAST({e} AS DOUBLE) AS {ty}) AS "{fld.name}"')
            else:
                cols.append(f'CAST({e} AS {ty}) AS "{fld.name}"' if ty else f'{e} AS "{fld.name}"')
        ctes.append(f"{f.stem} AS (SELECT {', '.join(cols)} FROM records "
                    f"WHERE service_name = '{svc}' AND span_name = 'doom.{f.stem}')")
    return ",\n".join(ctes)

def build(renderer_df, packed=None):
    sql = renderer_df.strip()
    # texels: one join on the 256-texel chunk, the texel read out of its string
    assert "LEFT JOIN texels tx ON tx.tkey = f.tkey" in sql
    sql = sql.replace("LEFT JOIN texels tx ON tx.tkey = f.tkey", "LEFT JOIN texel_chunks tx ON tx.ckey = (f.tkey >> 8)")
    sql = sql.replace("tx.tkey IS NOT NULL", f"{TEXEL} IS NOT NULL").replace("tx.palette_index", TEXEL)
    # output: hex colours, one row per scanline, plus the camera sector's floor height as row -1
    head, tail = sql.rsplit("SELECT f.pix, COALESCE(cm.rgb, f.fallback) AS rgb", 1)
    assert "colormap_rgb" in tail and "colormap_rgb" not in head
    cam = re.search(r"(\w+) AS \(\s*SELECT r\.\*, ps\.id AS ps_id, ps\.floor_height AS ps_floor", head).group(1)
    sql = head.rstrip() + f""",
frame_px AS (
  SELECT f.pix, COALESCE(substr(cm.hex, f.palette_index * 6 + 1, 6), lpad(to_hex(f.fallback), 6, '0')) AS hex
  FROM frame_index f
  LEFT JOIN (SELECT cm.level, cm.hex FROM colormap_rows cm JOIN hud h ON cm.pal = h.pal) cm ON cm.level = f.level
)
SELECT y, line FROM (
  SELECT CAST(pix / 320 AS INT) AS y, string_agg(hex, '' ORDER BY pix) AS line FROM frame_px GROUP BY 1
  UNION ALL
  SELECT -1 AS y, CAST(MIN(ps_floor) AS VARCHAR) AS line FROM {cam}
) ORDER BY y"""
    if packed:
        assert sql.startswith("WITH ")
        sql = "WITH " + prelude(packed) + ",\n" + sql[5:]
    return sql

def worker_template(frame_ff_sql):
    """frame_ff.sql with every constant folded; only ${svc}, ${px}, ${py}, ${pz} and ${angle} are left."""
    import port
    params = dict(port.CONSTANTS, map_id=1, player=157, skill=3, skill_bit=4,
                  px="CAST(${px} AS DOUBLE)", py="CAST(${py} AS DOUBLE)", pz="CAST(${pz} AS DOUBLE)",
                  vr="radians(CAST(${angle} AS DOUBLE))", sky_tex_id=691, sky_w=256)
    sql = frame_ff_sql
    for k, v in params.items():
        sql = sql.replace("${" + k + "}", str(v))
    left = set(re.findall(r"\$\{(\w+)\}", sql))
    assert left == {"svc", "px", "py", "pz", "angle"}, left
    return sql

if __name__ == "__main__":
    src, packed, out_local, out_ff = sys.argv[1:5]
    r = Path(src).read_text()
    Path(out_local).write_text(build(r)); Path(out_ff).write_text(build(r, packed))
    Path("worker/src/frame.sql").write_text(worker_template(Path(out_ff).read_text()))
    print(len(Path(out_local).read_text()), len(Path(out_ff).read_text()), len(Path("worker/src/frame.sql").read_text()))
