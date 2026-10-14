# The Logfire Doom proxy Worker on <account>.workers.dev.
#   tofu init && tofu apply -var account_id=... -var doom_read_token=...
# Credentials come from CLOUDFLARE_API_TOKEN (Workers Scripts: Edit on the account).
# The read token ends up in the state file, which is git-ignored; keep it local or in an encrypted backend.

terraform {
  required_version = ">= 1.8"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {}

variable "account_id" {
  type        = string
  description = "Cloudflare account to deploy the Worker in."
}

variable "doom_read_token" {
  type        = string
  sensitive   = true
  description = "Logfire read token for the project that holds the map spans."
}

variable "logfire_url" {
  type    = string
  default = "https://logfire-us.pydantic.dev"
}

variable "doom_service" {
  type        = string
  default     = "doom-e1m1"
  description = "service_name the map spans were ingested with."
}

variable "lookback_days" {
  type        = number
  default     = 30
  description = "How far back the query scans for the map spans. Ingest again before this runs out."
}

variable "allowed_origin" {
  type        = string
  default     = "https://adriangb.com"
  description = "The GitHub Pages origin that may call the Worker."
}

variable "frames_per_minute" {
  type        = number
  default     = 40
  description = "Per visitor IP. Each frame is about a 2 s query on Logfire."
}

locals {
  # The Worker imports the SQL as a text module; inline it so no bundler is needed.
  script = replace(
    file("${path.module}/../worker/src/index.js"),
    "import TEMPLATE from \"./frame.sql\";",
    "const TEMPLATE = ${jsonencode(file("${path.module}/../worker/src/frame.sql"))};",
  )
}

resource "cloudflare_workers_script" "doom" {
  account_id         = var.account_id
  script_name        = "logfire-doom"
  content            = local.script
  main_module        = "index.js"
  compatibility_date = "2026-09-01"

  bindings = [
    { type = "secret_text", name = "DOOM_READ_TOKEN", text = var.doom_read_token },
    { type = "plain_text", name = "LOGFIRE_URL", text = var.logfire_url },
    { type = "plain_text", name = "DOOM_SERVICE", text = var.doom_service },
    { type = "plain_text", name = "LOOKBACK_DAYS", text = tostring(var.lookback_days) },
    { type = "plain_text", name = "ALLOWED_ORIGIN", text = var.allowed_origin },
    {
      type         = "ratelimit"
      name         = "LIMITER"
      namespace_id = "1666"
      simple       = { limit = var.frames_per_minute, period = 60 }
    },
  ]
}

resource "cloudflare_workers_script_subdomain" "doom" {
  account_id       = var.account_id
  script_name      = cloudflare_workers_script.doom.script_name
  enabled          = true
  previews_enabled = false
}

variable "workers_subdomain" {
  type        = string
  description = "The account's workers.dev subdomain (Workers & Pages > Overview), used only for the output URL."
}

output "worker_url" {
  value = "https://logfire-doom.${var.workers_subdomain}.workers.dev"
}
