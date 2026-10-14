"""Send the packed Doom tables to Logfire as spans: one span per row, span name doom.<table>.

    DOOM_WRITE_TOKEN=... uv run --with httpx --with pyarrow ingest.py [service_name]

Prints the service name; play.py needs the same one (DOOM_SERVICE).
"""
import os, secrets, sys, time
from pathlib import Path
import httpx, pyarrow.parquet as pq

URL = os.environ.get("DOOM_LOGFIRE_URL", "https://logfire-us.pydantic.dev")
BATCH = 2000

def value(v):
    if isinstance(v, bool): return {"boolValue": v}
    if isinstance(v, int): return {"intValue": str(v)}
    if isinstance(v, float): return {"doubleValue": v}
    return {"stringValue": v}

def spans(packed, now):
    for f in sorted(Path(packed).glob("*.parquet")):
        for row in pq.read_table(f).to_pylist():
            yield {"traceId": secrets.token_hex(16), "spanId": secrets.token_hex(8), "name": f"doom.{f.stem}",
                   "kind": 1, "startTimeUnixNano": str(now), "endTimeUnixNano": str(now),
                   "attributes": [{"key": k, "value": value(v)} for k, v in row.items() if v is not None]}

def main():
    svc = sys.argv[1] if len(sys.argv) > 1 else f"doom-{secrets.token_hex(3)}"
    token = os.environ["DOOM_WRITE_TOKEN"]
    packed = Path(__file__).parent / "packed"
    now, batch, sent = time.time_ns(), [], 0
    with httpx.Client(timeout=120) as client:
        def flush():
            nonlocal sent, batch
            body = {"resourceSpans": [{"resource": {"attributes": [{"key": "service.name", "value": {"stringValue": svc}}]},
                                       "scopeSpans": [{"scope": {"name": "doom"}, "spans": batch}]}]}
            r = client.post(f"{URL}/v1/traces", json=body, headers={"Authorization": token})
            r.raise_for_status()
            sent += len(batch); batch = []
            print(f"\r{sent} spans", end="", flush=True)
        for s in spans(packed, now):
            batch.append(s)
            if len(batch) == BATCH: flush()
        if batch: flush()
    print(f"\nDOOM_SERVICE={svc}")

if __name__ == "__main__":
    main()
