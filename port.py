"""Translate SailDoom's Spark SQL renderer to DataFusion SQL."""
import re, sys
from pathlib import Path

SAILDOOM = Path(sys.argv[1]) if __name__ == "__main__" else None

def _bround(x):
    return f"(CASE WHEN ({x}) - floor({x}) = 0.5 THEN 2.0 * round(({x}) / 2.0) ELSE round({x}) END)"

def _firstlast(fn):
    def f(x, ignore=None):
        return f"{fn}({x})" + (" IGNORE NULLS" if ignore and ignore.lower() == "true" else "")
    return f

MACROS = {
    "GS": lambda a, b: f"unnest(range(CAST({a} AS BIGINT), CAST({b} AS BIGINT) + 1))",
    "PGINT": lambda x: f"CAST({_bround(x)} AS INT)",
    "bround": _bround,
    "sequence": lambda a, b: f"range(CAST({a} AS BIGINT), CAST({b} AS BIGINT) + 1)",
    "shiftleft": lambda a, b: f"(({a}) << ({b}))",
    "shiftright": lambda a, b: f"(({a}) >> ({b}))",
    "last": _firstlast("last_value"),
    "first": _firstlast("first_value"),
    "max_by": lambda a, b: f"first_value({a} ORDER BY {b} DESC)",
    "FHYPOT": lambda dx, dy: f"CAST(SQRT(CAST(POWER({dx}, 2) AS FLOAT) + CAST(POWER({dy}, 2) AS FLOAT)) AS FLOAT)",
    "DOOM_LIGHT_INDEX": lambda light, extra, att: (
        f"GREATEST(0, LEAST(31, (15 - LEAST(15, GREATEST(0, "
        f"CAST(FLOOR(CAST({light} AS DOUBLE) / 16.0) AS INT) + ({extra})))) * 4 - ({att})))"),
    "DOOM_LIGHT_SCALE": lambda depth: (
        f"CAST(FLOOR(LEAST(47.0, GREATEST(0.0, 2560.0 / NULLIF(CAST({depth} AS DOUBLE), 0.0))) / 2.0) AS INT)"),
    "DOOM_LIGHT_ZDEPTH": lambda depth: (
        f"CAST(FLOOR(80.0 / (LEAST(127, CAST(FLOOR(CAST({depth} AS DOUBLE) / 16.0) AS INT)) + 1)) AS INT)"),
}
_CALL = re.compile(r"(?<![\w.])(" + "|".join(MACROS) + r")\s*\(")

def _split_args(text):
    args, depth, start, quote = [], 0, 0, None
    for i, ch in enumerate(text):
        if quote:
            if ch == quote: quote = None
        elif ch == "'": quote = ch
        elif ch == "(": depth += 1
        elif ch == ")": depth -= 1
        elif ch == "," and depth == 0:
            args.append(text[start:i].strip()); start = i + 1
    args.append(text[start:].strip())
    return args

def expand(sql):
    while True:
        m = _CALL.search(sql)
        if not m: return sql
        depth, i = 1, m.end()
        while depth:
            depth += {"(": 1, ")": -1}.get(sql[i], 0); i += 1
        args = [expand(a) for a in _split_args(sql[m.end():i - 1])]
        sql = sql[:m.start()] + MACROS[m.group(1)](*args) + sql[i:]

def _star(sql):
    """a.s.* -> a.s['f'] AS f, ... with the fields of the next named_struct in the text."""
    while True:
        m = re.search(r"\b(\w+)\.(\w+)\.\*", sql)
        if not m: return sql
        j = sql.index("named_struct(", m.end()) + len("named_struct(")
        depth, i = 1, j
        while depth:
            depth += {"(": 1, ")": -1}.get(sql[i], 0); i += 1
        keys = [a.strip("'") for a in _split_args(sql[j:i - 1])[::2]]
        cols = ", ".join(f"{m.group(1)}.{m.group(2)}['{k}'] AS {k}" for k in keys)
        sql = sql[:m.start()] + cols + sql[m.end():]

CONSTANTS = {
    "W": "320", "H": "168", "CX": "160.0", "CY": "84.0",
    "FOCAL": "(160.0 / tan(radians(90.0) / 2.0))", "TANH": "tan(radians(90.0) / 2.0)",
    "NEAR": "1e-3", "MAXPD": "(16.0 * (160.0 / tan(radians(90.0) / 2.0)))",
    "ROT_OFF": "202.5", "ROT_SPAN": "45.0", "SKY_COLS": "256.0", "SKY_DEG": "90.0",
    "SKY_ROWS": "128", "SKY_HY": "100", "FLAT": "64", "INVULN": "32", "PSP_BIAS": "23",
}

def translate(spark_sql):
    sql = re.sub(r"--[^\n]*", "", spark_sql)
    sql = re.sub(r"(?<=[0-9.])D\b", "", sql)          # 1.0D -> 1.0
    sql = re.sub(r"\bDIV\b", "/", sql)
    sql = re.sub(r"\bexplode\s*\(", "unnest(", sql)
    sql = re.sub(r"(?<![\w.])array\s*\(", "make_array(", sql)
    sql = re.sub(r"([\w.]+)\s+IS\s+(NOT\s+)?DISTINCT\s+FROM\s+('[^']*'|[\w.]+)", r"(\1 IS \2DISTINCT FROM \3)", sql)
    sql = _star(sql)
    sql = re.sub(r"(?<![\w.'])([A-Za-z_]\w*)\.([A-Za-z_]\w*)\.([A-Za-z_]\w*)\b(?!\s*\()", r"\1.\2['\3']", sql)
    return expand(sql)

def fold(sql, pose, map_id=1, player=1, skill=3, sky_tex_id=691, sky_w=256):
    x, y, z, angle = (float(v) for v in pose)
    lit = lambda v: f"CAST({v!r} AS DOUBLE)"
    params = dict(CONSTANTS, map_id=map_id, player=player, skill=skill,
                  skill_bit=1 if skill <= 1 else 2 if skill == 2 else 4,
                  px=lit(x), py=lit(y), pz=lit(z), vr=f"radians({lit(angle)})",
                  sky_tex_id=sky_tex_id, sky_w=sky_w)
    for k, v in params.items():
        sql = sql.replace("${" + k + "}", str(v))
    assert "${" not in sql, sql[sql.index("${"):][:40]
    return sql

if __name__ == "__main__":
    out = translate((SAILDOOM / "sql" / "renderer.sql").read_text())
    Path(sys.argv[2]).write_text(out)
    print(len(out), "bytes")
