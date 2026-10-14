"""Pack the map's render tables into the rows that go to Logfire: one row per span.

Small tables go as they are (only the columns the renderer reads). The two big
ones are packed so the whole map is about 90k spans instead of 3.5M:
  texel_chunks(ckey, s)      256 texels per row; s[i] = chr(256 + palette_index), '.' = no texel
  colormap_rows(pal, level, hex)   256 colours per row, 6 hex digits each
"""
import re, sys
from pathlib import Path
import numpy as np, pyarrow as pa, pyarrow.parquet as pq

SHIFT = 8
BIG = {"texels", "colormap_rgb"}

def pack(mapdir, sql, out):
    mapdir, out = Path(mapdir), Path(out)
    out.mkdir(parents=True, exist_ok=True)
    names = [f.stem for f in sorted(mapdir.glob("*.parquet"))
             if re.search(r"\b(FROM|JOIN)\s+" + f.stem + r"\b", sql)]
    for name in names:
        if name in BIG: continue
        t = pq.read_table(mapdir / f"{name}.parquet")
        cols = [f.name for f in t.schema if re.search(r"\b" + f.name + r"\b", sql)
                and not pa.types.is_binary(f.type)]
        pq.write_table(t.select(cols), out / f"{name}.parquet")

    t = pq.read_table(mapdir / "texels.parquet")
    key, idx = t.column("tkey").to_numpy(), t.column("palette_index").to_numpy()
    ck = key >> SHIFT
    uniq, inv = np.unique(ck, return_inverse=True)
    grid = np.full((len(uniq), 1 << SHIFT), ord("."), dtype=np.uint32)
    grid[inv, key & ((1 << SHIFT) - 1)] = 256 + idx
    strings = ["".join(map(chr, row)) for row in grid]
    pq.write_table(pa.table({"ckey": pa.array(uniq, pa.int64()), "s": strings}), out / "texel_chunks.parquet")

    t = pq.read_table(mapdir / "colormap_rgb.parquet").to_pydict()
    rows = {}
    for pal, level, pi, rgb in zip(t["pal"], t["level"], t["palette_index"], t["rgb"]):
        rows.setdefault((pal, level), {})[pi] = rgb
    recs = [(p, l, "".join(f"{v[i]:06x}" for i in range(256))) for (p, l), v in sorted(rows.items())]
    assert all(len(v) == 256 for v in rows.values())
    pq.write_table(pa.table({"pal": pa.array([r[0] for r in recs], pa.int32()),
                             "level": pa.array([r[1] for r in recs], pa.int32()),
                             "hex": [r[2] for r in recs]}), out / "colormap_rows.parquet")
    total = 0
    for f in sorted(out.glob("*.parquet")):
        n = pq.read_metadata(f).num_rows; total += n
    print("tables", len(list(out.glob('*.parquet'))), "rows", total)

if __name__ == "__main__":
    pack(sys.argv[1], Path(sys.argv[2]).read_text(), sys.argv[3])
