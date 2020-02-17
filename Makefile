#!/bin/bash

RED=\033[0;31m
NC=\033[0m

help:
	@echo "###########################################################################################################"
	@echo "# make up : Up Containers                                                                                 #"
	@echo "# make down :Down Containers                                                                              #"
	@echo "# make stop :Stop Containers                                                                              #"
	@echo "# make start :Start Containers                                                                            #"
	@echo "# make shell : Shell into Drupal container                                                                #"
	@echo "# make backup-drupal : Backup the  Drupal container                                                       #"
	@echo "# make restore-drupal : Restor the Drupal container                                                       #"
	@echo "# make logs-drupal : display Drupal logs                                                                  #"
	@echo "# make docker-clear-all : $(RED)Warning$(NC) To use with caution remove Drupal container and his volumes             #"
	@echo "###########################################################################################################"

BACKUP_FOLDER=$(CURDIR)/backup

docker-clear-all: down purge-images remove-volume

backup-drupal: backup-drupal-container backup-mysql-container

restore-drupal: stop restore-drupal-container restore-mysql-container start

up:
	docker-compose up -d

stop:
	docker-compose stop

start:
	docker-compose start

down:
	docker-compose down

shell:
	docker-compose exec drupal bash

logs-drupal:
	docker-compose logs -f | grep drupal

update-drupal:
	docker-compose down && \
	docker rmi obiba/docker-obiba-drupal && \
	docker-compose pull && \
	docker-compose up -d

purge-images:
	docker rmi obiba/docker-obiba-drupal && \

remove-volume:
	rm -rf /var/lib/docker/volumes/obibadocker_drupal_sites/_data/* && \
	rm -rf /data/containers/mysql_db/*

backup-drupal-container:
	docker export obibadocker_drupal_1 | gzip > $(BACKUP_FOLDER)/drupal.gz && \
	cd /var/lib/docker/volumes/obibadocker_drupal_sites/_data/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_volume.gz *

backup-mysql-container:
	docker export yorkdocker_mysql_1 | gzip > $(BACKUP_FOLDER)/mysql.gz && \
	cd /data/containers/mysql_db/ && \
	tar -cvf $(BACKUP_FOLDER)/mysql_volume.gz *

restore-drupal-container:
	zcat $(BACKUP_FOLDER)/drupal.gz | docker import - obibadocker_drupal_1 && \
	cp $(BACKUP_FOLDER)/drupal_volume.gz /var/lib/docker/volumes/obibadocker_drupal_sites/_data/ && \
	cd /var/lib/docker/volumes/obibadocker_drupal_sites/_data/ && \
	tar -xvf drupal_volume.gz


restore-mysql-container:
	zcat $(BACKUP_FOLDER)/mysql.gz | docker import - yorkdocker_mysql_1 && \
	cp $(BACKUP_FOLDER)/mysql_volume.gz /data/containers/mysql_db/ && \
	cd /data/containers/mysql_db/ && \
	tar -xvf mysql_volume.gz