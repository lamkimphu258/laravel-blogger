USER_ID=`id -u ${USER}`
GROUP_ID=`id -g ${USER}`
API_PATH=/var/www
WAIT=10

artisan_cmd:
	docker-compose exec \
	app \
	php artisan --verbose $(cmd)

user:
	echo ${USER_ID}
	echo ${GROUP_ID}

composer_cmd: start_api
	docker-compose exec \
	app \
	composer $(cmd)

composer_require: composer_cmd cmd=require $(package)

migration_generate:
	$(MAKE) artisan_cmd cmd=migrate

migration_rollback:
	$(MAKE) artisan_cmd cmd=migrate:rollback

migration_fresh:
	$(MAKE) artisan_cmd cmd=migrate:fresh

seed_db:
	$(MAKE) artisan_cmd cmd=db:seed

tinker:
	$(MAKE) artisan_cmd cmd=tinker

init_db:
	$(MAKE) artisan_cmd cmd=migrate:fresh
	$(MAKE) artisan_cmd cmd=db:seed

start_api: 
	docker-compose up -d

stop_api:
	docker-compose down

restart_api: stop_api
	$(MAKE) start_api

clear_caches:
	docker-compose exec \
	app
	$(MAKE) artisan_cmd cmd=config:clear
	$(MAKE) artisan_cmd cmd=cache:clear
	$(MAKE) artisan_cmd cmd=route:clear
	$(MAKE) artisan_cmd cmd=config:cache

init_env: 
	ln -s ./src/.env .env
