run_grafana:
	docker compose -f 'compose.grafana.yml' down
	docker compose -f 'compose.grafana.yml' up -d

run_grafana_dev:
	docker compose -f 'compose.grafana.dev.yml' down
	docker compose -f 'compose.grafana.dev.yml' up -d