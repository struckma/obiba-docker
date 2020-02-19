#!/bin/bash

EXPORT_FOLDER=$(CURDIR)/export_folder
IMPORT_FOLDER=$(CURDIR)/import_folder
DOCKER_DRUPAL=obibadocker_drupal_1

export-drupal-build: export-drupal-docker export-drupal-libraries export-drupal-modules export-drupal-themes export-drupal-vendor build-package

import-drupal-build: extract-pakage import-drupal-docker import-drupal-libraries import-drupal-modules import-drupal-themes import-drupal-vendor update-composer

export-drupal-docker:
	docker export $(DOCKER_DRUPAL) | gzip > $(EXPORT_FOLDER)/drupal_images.gz

export-drupal-libraries:
	cd $(DRUPAL_VOLUMES)_libraries/_data/ && tar -cvf drupal_libraries.tar * && mv drupal_libraries.tar $(EXPORT_FOLDER)/

export-drupal-modules:
	cd $(DRUPAL_VOLUMES)_modules/_data/ && tar -cvf drupal_modules.tar * && mv drupal_modules.tar $(EXPORT_FOLDER)/

export-drupal-themes:
	cd $(DRUPAL_VOLUMES)_themes/_data/ && tar -cvf drupal_themes.tar * && mv drupal_themes.tar $(EXPORT_FOLDER)/

export-drupal-vendor:
	cd $(DRUPAL_VOLUMES)_vendor/_data/ && tar -cvf drupal_vendor.tar * && mv drupal_vendor.tar $(EXPORT_FOLDER)/

build-package:
	cd $(EXPORT_FOLDER)/ && tar -cvf drupal_container.tar * && \
	rm -rf drupal_libraries.tar && \
	rm -rf drupal_modules.tar && \
	rm -rf drupal_themes.tar && \
	rm -rf drupal_vendor.tar && \
	rm -rf drupal_images.gz

extract-pakage:
	cd $(IMPORT_FOLDER)/ && \
	tar -xvf drupal_container.tar

import-drupal-docker:
	zcat $(IMPORT_FOLDER)/drupal.gz | docker import - $(DOCKER_DRUPAL)

import-drupal-default:
	cp $(IMPORT_FOLDER)/drupal_default.tar $(DRUPAL_VOLUMES)_default/_data/ && \
    cd $(DRUPAL_VOLUMES)_default/_data/ && \
    tar -xvf drupal_default.tar

import-drupal-libraries:
	cp $(IMPORT_FOLDER)/drupal_libraries.tar $(DRUPAL_VOLUMES)_libraries/_data/ && \
    cd $(DRUPAL_VOLUMES)_libraries/_data/ && \
    tar -xvf drupal_libraries.tar

import-drupal-modules:
	cp $(IMPORT_FOLDER)/drupal_modules.tar $(DRUPAL_VOLUMES)_modules/_data/ && \
    cd $(DRUPAL_VOLUMES)_modules/_data/ && \
    tar -xvf drupal_modules.tar

import-drupal-themes:
	cp $(IMPORT_FOLDER)/drupal_themes.tar $(DRUPAL_VOLUMES)_themes/_data/ && \
    cd $(DRUPAL_VOLUMES)_themes/_data/ && \
    tar -xvf drupal_themes.tar

import-drupal-vendor:
	cp $(IMPORT_FOLDER)/drupal_vendor.tar $(DRUPAL_VOLUMES)_vendor/_data/ && \
    cd $(DRUPAL_VOLUMES)_vendor/_data/ && \
    tar -xvf drupal_vendor.tar

update-composer:
	docker exec -d $(DOCKER_DRUPAL) make obiba-composer-conf