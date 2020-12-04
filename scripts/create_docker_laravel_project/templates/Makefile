# PROJECT_NAME

dummy:
	@echo PROJECT_NAME Makefile.

install:
	git submodule update --init
	composer install
	docker-compose build
	docker-compose run php php artisan clear-compiled
	npm install

clear:
	docker-compose exec php php composer.phar dump-autoload --optimize
	docker-compose exec php php artisan clear-compiled
	docker-compose exec php php artisan view:clear
	rm -rf storage/app/*
	rm -rf storage/logs/*
	rm -rf storage/debugbar/*

up:
	docker-compose up -d --build

down:
	docker-compose down

php:
	docker-compose exec php sh

nginx:
	docker-compose exec nginx sh

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
