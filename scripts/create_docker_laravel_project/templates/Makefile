# PROJECT_NAME
# for local development.

dummy:
	@echo PROJECT_NAME Makefile.

setup:
	docker-compose build
	docker-compose run php composer install
	touch .env
	CACHE_DRIVER=array composer install
	@if [ "`grep '^CACHE_DRIVER=array' .env`" ]; then \
			echo ; \
		elif [ "`grep '^CACHE_DRIVER=' .env`" ]; then \
			gsed -i -e "s/^CACHE_DRIVER=.*/CACHE_DRIVER=array/g" .env ; \
		else \
			echo "CACHE_DRIVER=array" >> .env ; \
		fi
	@if [ "`grep '^APP_KEY=.\+' .env`" ]; then \
			echo ; \
		elif [ "`grep '^APP_KEY=' .env`" ]; then \
			docker-compose run php php artisan key:generate ; \
		else \
			echo "APP_KEY=" >> .env ; \
			docker-compose run php php artisan key:generate ; \
		fi
	@echo
	@echo done.

install:
	git submodule update --init
	composer install
	docker-compose build
	docker-compose run php composer install
	docker-compose run php php artisan clear-compiled
	npm install
	npm run dev

clear:
	docker-compose run php sh -c "\
		composer dump-autoload --optimize ; \
		php artisan clear-compiled ; \
		php artisan view:clear"
	rm -rf storage/app/*
#	rm -rf storage/logs/*
	rm -rf storage/debugbar/*
	git checkout storage
	docker-compose run php php artisan cache:clear

up:
	docker-compose up -d --build

down:
	docker-compose down

php:
	docker-compose exec php sh

nginx:
	docker-compose exec nginx sh

DATABASE_IMAGE:
	docker-compose exec DATABASE_IMAGE bash

migrate:
	docker-compose exec php php artisan migrate

migrate-rollback:
	docker-compose exec php php artisan migrate:rollback

migrate-refresh:
	docker-compose run php php artisan migrate:refresh

logs:
	docker-compose logs -f

log:
	tail -f ./storage/logs/*

watch:
	npm run watch

dev:
	npm run dev

test:
	docker-compose exec php php artisan test

open:
	open http://localhost:NGINX_PORT

# cs-fixer
fix-diff:
	docker-compose run php ./vendor/bin/php-cs-fixer fix --dry-run --diff -v

fix-v:
	docker-compose run php ./vendor/bin/php-cs-fixer fix --dry-run -v

fix:
	docker-compose run php ./vendor/bin/php-cs-fixer fix -v

#
# tasks
#

sample-inspire:
	docker-compose exec php php artisan inspire
