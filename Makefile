# It's necessary to set this because some environments don't link sh -> bash.
# https://github.com/kubernetes/kubernetes/blob/master/build/root/Makefile
SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset

PROFILE ?=
LOCAL ?= false

# Ensure PROFILE is provided
ifeq ($(PROFILE),)
$(error PROFILE is required. Usage: make run PROFILE=<profile_name> [LOCAL=true])
endif

# Define the command based on LOCAL flag
ifeq ($(LOCAL),true)
    COMPOSE_CMD = docker compose -f docker-compose.local.yaml --profile $(PROFILE) up  -d --build
else
    COMPOSE_CMD = docker compose -f docker-compose.yaml --profile $(PROFILE) up -d --build
endif

.PHONY: start
start:
	@$(COMPOSE_CMD)
