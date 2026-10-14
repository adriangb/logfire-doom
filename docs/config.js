// The deployed Cloudflare Worker (see worker/). Override with ?worker=<url> for testing.
window.DOOM_WORKER = new URLSearchParams(location.search).get("worker") || "https://logfire-doom.adriangb.workers.dev";
