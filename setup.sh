#!/usr/bin/env bash
# First-time setup: .env and secrets. Safe to run again.
set -euo pipefail
cd "$(dirname "$0")"

[[ -f .env ]] || { cp .env.example .env; echo "created .env"; }
umask 077
mkdir -p secrets
if [[ ! -s secrets/grafana_admin_password ]]; then
  head -c 24 /dev/urandom | base64 | tr -d '/+=' > secrets/grafana_admin_password
  echo "generated Grafana admin password: secrets/grafana_admin_password"
fi
if [[ ! -s secrets/discord_webhook ]]; then
  read -r -p "Discord webhook URL for alerts (Enter to skip): " hook
  echo "${hook:-https://discord.com/api/webhooks/000/placeholder}" > secrets/discord_webhook
fi
sudo install -d -m 0755 /var/lib/node_exporter/textfile_collector
echo "next: edit prometheus/targets/*.yml, then: docker compose up -d"
