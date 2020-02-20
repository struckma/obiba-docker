#!/bin/bash

logs-drupal:
	docker-compose logs -f | grep drupal

update-drupal:
	docker-compose down && \
	docker rmi obiba/docker-obiba-drupal && \
	docker-compose pull && \
	docker-compose up -d

backup-drupal-docker:
	docker export obiba-docker_drupal_1 | gzip > $(BACKUP_FOLDER)/drupal_images.gz

backup-drupal-default:
	cd $(DRUPAL_VOLUMES)/drupal_sites_default/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_default.tar *

backup-drupal-libraries:
	cd $(DRUPAL_VOLUMES)/drupal_sites_libraries/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_libraries.tar *

backup-drupal-modules:
	cd $(DRUPAL_VOLUMES)/drupal_sites_modules/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_modules.tar *

backup-drupal-themes:
	cd $(DRUPAL_VOLUMES)/drupal_sites_themes/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_themes.tar *

backup-drupal-vendor:
	cd $(DRUPAL_VOLUMES)/drupal_sites_vendor/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_vendor.tar *

restore-drupal-docker:
	gzip -dc $(BACKUP_FOLDER)/drupal_images.gz | docker import - obiba-docker_drupal_1

restore-drupal-default:
	mkdir -p $(DRUPAL_VOLUMES)/drupal_sites_default/ && \
    cp $(BACKUP_FOLDER)/drupal_default.tar $(DRUPAL_VOLUMES)/drupal_sites_default/ && \
    cd $(DRUPAL_VOLUMES)/drupal_sites_default/ && \
    tar -xvf drupal_default.tar

restore-drupal-libraries:
	mkdir -p $(DRUPAL_VOLUMES)/drupal_sites_libraries/ && \
    cp $(BACKUP_FOLDER)/drupal_libraries.tar $(DRUPAL_VOLUMES)/drupal_sites_libraries/ && \
    cd $(DRUPAL_VOLUMES)/drupal_sites_libraries/ && \
    tar -xvf drupal_libraries.tar

restore-drupal-modules:
	mkdir -p $(DRUPAL_VOLUMES)/drupal_sites_modules/ && \
    cp $(BACKUP_FOLDER)/drupal_modules.tar $(DRUPAL_VOLUMES)/drupal_sites_modules/ && \
    cd $(DRUPAL_VOLUMES)/drupal_sites_modules/ && \
    tar -xvf drupal_modules.tar

restore-drupal-themes:
	mkdir -p $(DRUPAL_VOLUMES)/drupal_sites_themes/ && \
    cp $(BACKUP_FOLDER)/drupal_themes.tar $(DRUPAL_VOLUMES)/drupal_sites_themes/ && \
    cd $(DRUPAL_VOLUMES)/drupal_sites_themes/ && \
    tar -xvf drupal_themes.tar

restore-drupal-vendor:
	mkdir -p $(DRUPAL_VOLUMES)/drupal_sites_vendor/ && \
    cp $(BACKUP_FOLDER)/drupal_vendor.tar $(DRUPAL_VOLUMES)/drupal_sites_vendor/ && \
    cd $(DRUPAL_VOLUMES)/drupal_sites_vendor/ && \
    tar -xvf drupal_vendor.tar
