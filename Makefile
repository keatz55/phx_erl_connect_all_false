#!make
-include .env.dev
export $(shell test -f .env.dev && sed 's/=.*//' .env.dev)

SHELL := /bin/bash

.PHONY: test

### App1 ######

app1.iex:
	docker attach app1 --detach-keys=ctrl-c

app1.logs:
	docker logs app1

app1.ssh:
	docker exec -it app1 ash

### App2 ######

app2.iex:
	docker attach app2 --detach-keys=ctrl-c

app2.logs:
	docker logs app2

app2.ssh:
	docker exec -it app2 ash

### App3 ######

app3.iex:
	docker attach app3 --detach-keys=ctrl-c

app3.logs:
	docker logs app3

app3.ssh:
	docker exec -it app3 ash

### Docker Compose ######

compose.up:
	docker-compose up -d --build
	docker-compose ps

compose.down:
	docker-compose down
