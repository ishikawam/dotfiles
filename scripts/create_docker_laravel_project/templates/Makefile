# PROJECT_NAME
# for local development.

dummy:
	@echo PROJECT_NAME Makefile.

setup:
	@if [ -s .env ]; then echo ; echo Error! .env is exists. ; echo ; exit 1 ; fi
	echo 'APP_KEY=' > .env
	php artisan key:generate
	@echo
	@echo done.

install:
	git submodule update --init
	composer install
	docker-compose build
	php artisan clear-compiled
	npm install

clear:
	composer dump-autoload --optimize
	php artisan clear-compiled
	php artisan view:clear
	rm -rf storage/app/*
	rm -rf storage/logs/*
	rm -rf storage/debugbar/*
	git checkout storage

up:
	docker-compose up -d --build

down:
	docker-compose down

php:
	docker-compose exec php sh

nginx:
	docker-compose exec nginx sh

mysql:
	docker-compose exec mysql bash
migrate:
	docker-compose exec php php artisan migrate

migrate-rollback:
	docker-compose exec php php artisan migrate:rollback

logs:
	docker-compose logs -f

log:
	tail -f ./storage/logs/*

open:
	open http://localhost:NGINX_PORT

# cs-fixer
fix-diff:
	./vendor/bin/php-cs-fixer fix --dry-run --diff -v

fix-v:
	./vendor/bin/php-cs-fixer fix --dry-run -v

fix:
	./vendor/bin/php-cs-fixer fix -v
