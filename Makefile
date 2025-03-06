# It's necessary to set this because some environments don't link sh -> bash.
# https://github.com/kubernetes/kubernetes/blob/master/build/root/Makefile
SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset

.PHONY: start stop
start-%:
	docker compose --profile $* up -d --build
start:
	docker compose up -d --build
stop-%:
	docker compose --profile $* down
stop:
	docker compose down