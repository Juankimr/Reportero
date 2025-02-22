.DEFAULT_GOAL := help

# Define variables for repeated commands
DOCKER_COMPOSE = docker compose
APP_NAME = app

.PHONY: help
help:  ## Show this help.
	@grep -E '^\S+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: build
build: ## Build the docker image
	$(DOCKER_COMPOSE) build

.PHONY: up
up: ## Run the docker container
	$(DOCKER_COMPOSE) up -d

.PHONY: down
down: ## Stop the docker container
	$(DOCKER_COMPOSE) down

.PHONY: add
add: ## Add package to the project ex: make add package=XX
	$(DOCKER_COMPOSE) run --rm --no-deps $(APP_NAME) uv add $(package)
	make build

.PHONY: add-dev
add-dev: ## Add dev package to the project ex: make add-dev package=XX
	$(DOCKER_COMPOSE) run --rm --no-deps $(APP_NAME) uv add --dev $(package)
	make build

.PHONY: test-unit
test-unit: ## Run unit tests
	$(DOCKER_COMPOSE) run --rm $(APP_NAME) uv run pytest test/unit -ra

.PHONY: test-integration
test-integration: ## Run integration tests
	$(DOCKER_COMPOSE) run --rm $(APP_NAME) uv run pytest test/integration -ra

.PHONY: test-acceptance
test-acceptance: ## Run acceptance tests
	$(DOCKER_COMPOSE) run --rm $(APP_NAME) uv run pytest test/acceptance -ra

.PHONY: test
test: test-unit
#  test-integration test-acceptance ## Run tests

.PHONY: coverage
coverage: ## Run coverage
	$(DOCKER_COMPOSE) run --rm $(APP_NAME) sh -c "\
		rm -f .coverage && \
		coverage run --branch -m pytest test && \
		coverage report -m && \
		coverage html --directory coverage && \
		coverage json && mv coverage.json coverage/coverage.json && \
		coverage xml && mv coverage.xml coverage/coverage.xml"
