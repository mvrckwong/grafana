deploy_grafana:
	docker compose -f 'compose.grafana.yml' down
	docker compose -f 'compose.grafana.yml' up -d --force-recreate --remove-orphans