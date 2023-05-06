user = 1000
group = 1000

start:	
	docker compose -f ./deploy/development/docker-compose.yaml up -d
	docker compose -f ./deploy/development/docker-compose.yaml logs -f

stop:	
	docker compose -f ./deploy/development/docker-compose.yaml down --remove-orphans 

build:
	docker compose -f ./deploy/development/docker-compose.yaml build

logs:
	docker compose -f ./deploy/development/docker-compose.yaml logs -f

install: 
	docker compose -f ./deploy/development/install.yaml up
	cp .env.template .env
	
	

create-nest-service:  ## add new next service to enviromnent
	@read -p "enter proyect name: " name; \
	docker compose -f ./deploy/development/tools.yaml run --user=$(user):$(group) -it --rm nest bash -c "nest new $$name"

create-angular-app:  ## add new angular app to enviromnent
	@read -p "enter proyect name: " name; \
	docker compose -f ./deploy/development/tools.yaml run --user=$(user):$(group) -it --rm angular bash -c "ng new $$name"

service-cli:  ## bash access using cli over project
	@read -p "what? frontend | auth-service | backend | admin-panel: " service; \
	docker compose -f ./deploy/development/docker-compose.yaml run --user=$(user):$(group) -it --rm $$service bash	

cleanup: ## lo que hace
	docker rm -f $$(docker ps -aq)

remove:	## borra
	@read -p "what remove inside data?: " directory; \
	docker compose -f ./deploy/tools/docker-compose.yaml run --rm data rm -Rf $$directory/*

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


generate-env:
	cp .env.template .env