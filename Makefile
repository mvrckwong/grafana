deploy:
	docker compose -f compose.grafana.yml down --remove-orphans
	docker compose -f compose.grafana.yml up -d --build --force-recreate --remove-orphans

reset_data:
	docker volume rm grafana-monitoring_postgres_data