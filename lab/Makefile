.DEFAULT_GOAL := help
CURRENT_DIR := $(CURDIR)

.PHONY: help
help: ## Display help message
	@printf '%s\n' 'start    Deploy/reconfigure the topology' 'stop     Destroy the topology' 'inspect  Inspect the lab'

##################################################
# Containerlab
##################################################

# Keep the standard acLabs topology layout for deployment and readiness.
TOPOLOGY := $(CURRENT_DIR)/clab/topology.clab.yml

.PHONY: start
start: ## Deploy the lab (retries once on a partial deploy; log in .lab/deploy.log)
	@if [ -x /bin/lab-deploy.sh ]; then \
		/bin/lab-deploy.sh deploy "$(TOPOLOGY)"; \
	else \
		sudo containerlab deploy --debug --topo "$(TOPOLOGY)" --max-workers 10 --timeout 5m --reconfigure; \
	fi

.PHONY: stop
stop: ## Destroy the lab
	@if [ -x /bin/lab-deploy.sh ]; then \
		/bin/lab-deploy.sh destroy "$(TOPOLOGY)"; \
	else \
		sudo containerlab destroy --debug --topo "$(TOPOLOGY)" --cleanup; \
	fi

.PHONY: inspect
inspect: ## Inspect the lab
	@sudo containerlab inspect --topo "$(TOPOLOGY)"
	@echo ""
	@echo "You can check the lab status, hostnames and management addresses above."
	@echo "To connect to a lab device use \`ssh admin@<hostname>\` and password \`admin\`."
