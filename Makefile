.DEFAULT_GOAL := help
.PHONY: help start stop

DEVCONTAINER ?= devcontainer
DOCKER ?= docker
LAB_CONFIG := $(CURDIR)/.devcontainer/devcontainer.json

help: ## Show host shortcuts
	@printf '%s\n' 'start  Rebuild without cache, recreate the editor container and initialize the lab' 'stop   Stop this workspace editor container'

start: ## Rebuild without cache, recreate the editor container and initialize the lab
	$(DEVCONTAINER) up --docker-path "$(DOCKER)" --workspace-folder "$(CURDIR)" --config "$(LAB_CONFIG)" --remove-existing-container --build-no-cache

stop: ## Stop this workspace's editor container; preserve its Docker volume
	@ids="$$( $(DOCKER) ps -q --filter 'label=devcontainer.local_folder=$(CURDIR)' --filter 'label=devcontainer.config_file=$(LAB_CONFIG)')" || exit $$?; \
	if [ -n "$$ids" ]; then printf '%s\n' "$$ids" | xargs $(DOCKER) stop; else echo "RCF quickstart container is already stopped."; fi
