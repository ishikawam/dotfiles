# PROJECT_NAME

dummy:
	@echo PROJECT_NAME Makefile.

install:
	git submodule update --init
	composer install
	docker-compose build
	docker-compose run php php artisan clear-compiled
	npm install

up:
	docker-compose up -d --build

down:
	docker-compose down

php:
	docker-compose exec php sh

nginx:
	docker-compose exec nginx sh

logs:
	docker-compose logs -f

log:
	tail -f ./storage/logs/*

open:
	open http://localhost:NGINX_PORT
