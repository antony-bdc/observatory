.PHONY: check test validate reload

check:
	promtool check config prometheus/prometheus.yml
	promtool check rules prometheus/rules/*.yml
	amtool check-config alertmanager/alertmanager.yml
	python3 -m json.tool grafana/dashboards/homelab-overview.json > /dev/null && echo "dashboard JSON valid"

test:
	promtool test rules tests/rules_test.yml

validate:
	@mkdir -p secrets; for s in discord_webhook grafana_admin_password; do test -f secrets/$$s || echo ci > secrets/$$s; done
	docker compose --env-file .env.example config --quiet && echo "compose file valid"

reload: ## apply config changes without restarting
	curl -fsS -X POST http://127.0.0.1:9090/-/reload && echo "prometheus reloaded"
