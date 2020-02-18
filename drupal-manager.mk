#!/bin/bash

logs-drupal:
	docker-compose logs -f | grep drupal

update-drupal:
	docker-compose down && \
	docker rmi obiba/docker-obiba-drupal && \
	docker-compose pull && \
	docker-compose up -d

backup-drupal-docker:
	docker export obibadocker_drupal_1 | gzip > $(BACKUP_FOLDER)/drupal_images.gz

backup-drupal-default:
	cd /var/lib/docker/volumes/obibadocker_drupal_sites_default/_data/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_default.tar *

backup-drupal-libraries:
	cd /var/lib/docker/volumes/obibadocker_drupal_sites_libraries/_data/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_libraries.tar *

backup-drupal-modules:
	cd /var/lib/docker/volumes/obibadocker_drupal_sites_modules/_data/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_modules.tar *

backup-drupal-themes:
	cd /var/lib/docker/volumes/obibadocker_drupal_sites_themes/_data/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_themes.tar *

backup-drupal-vendor:
	cd /var/lib/docker/volumes/obibadocker_drupal_sites_vendor/_data/ && \
	tar -cvf $(BACKUP_FOLDER)/drupal_vendor.tar *

restore-drupal-docker:
	zcat $(BACKUP_FOLDER)/drupal.gz | docker import - obibadocker_drupal_1

restore-drupal-default:
	cp $(BACKUP_FOLDER)/drupal_default.tar /var/lib/docker/volumes/obibadocker_drupal_sites_default/_data/ && \
    cd /var/lib/docker/volumes/obibadocker_drupal_sites_default/_data/ && \
    tar -xvf drupal_default.tar

restore-drupal-libraries:
	cp $(BACKUP_FOLDER)/drupal_libraries.tar /var/lib/docker/volumes/obibadocker_drupal_sites_libraries/_data/ && \
    cd /var/lib/docker/volumes/obibadocker_drupal_sites_libraries/_data/ && \
    tar -xvf drupal_libraries.tar

restore-drupal-modules:
	cp $(BACKUP_FOLDER)/drupal_modules.tar /var/lib/docker/volumes/obibadocker_drupal_sites_modules/_data/ && \
    cd /var/lib/docker/volumes/obibadocker_drupal_sites_modules/_data/ && \
    tar -xvf drupal_modules.tar

restore-drupal-themes:
	cp $(BACKUP_FOLDER)/drupal_themes.tar /var/lib/docker/volumes/obibadocker_drupal_sites_themes/_data/ && \
    cd /var/lib/docker/volumes/obibadocker_drupal_sites_themes/_data/ && \
    tar -xvf drupal_themes.tar

restore-drupal-vendor:
	cp $(BACKUP_FOLDER)/drupal_vendor.tar /var/lib/docker/volumes/obibadocker_drupal_sites_vendor/_data/ && \
    cd /var/lib/docker/volumes/obibadocker_drupal_sites_vendor/_data/ && \
    tar -xvf drupal_vendor.tar
