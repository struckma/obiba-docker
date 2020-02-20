Production Ready Obiba Suite app
===============================


This docker-compose pull Obiba images from :
* [obiba/docker-obiba-drupal](https://hub.docker.com/repository/docker/obiba/docker-obiba-drupal)
* [obiba/mica](https://hub.docker.com/repository/docker/obiba/mica)
* [obiba/opal](https://hub.docker.com/repository/docker/obiba/opal)
* [obiba/agate](https://hub.docker.com/repository/docker/obiba/agate)
* [obiba/opal-rserver](https://hub.docker.com/repository/docker/obiba/opal-rserver)
* [obiba/onyx-demo](https://hub.docker.com/repository/docker/obiba/onyx-demo)

## Usage
Please take a look at the Makefile that defines some basic commands to manage the Obiba docker containers, run `make help` for more information.
First all  please create the necessary folders by typing: `make init` 

## Volumes location
The volumes are stored in these folders (or in the case of drupal, managed by docker) :
 
* Drupal in the default docker volumes location : 
    * ./volumes/obibadocker_drupal_sites/obibadocker_drupal_sites_default/
    * ./volumes/obibadocker_drupal_sites/obibadocker_drupal_sites_libraries/
    * ./volumes/obibadocker_drupal_sites/obibadocker_drupal_sites_modules/
    * ./volumes/obibadocker_drupal_sites/obibadocker_drupal_sites_themes/
    * ./volumes/obibadocker_drupal_sites/obibadocker_drupal_sites_themes/

* Mica : ./volumes/data/containers/mica_srv
* Opal : ./volumes/data/containers/opal_srv
* Agate : ./volumes/data/containers/agate_srv
* Mongo :  ./volumes/data/containers/mongo_configdb  and /data/containers/mongo_db
* mysql : ./volumes/data/containers/mysql_db

> Make sure that the user that runs dcoker-compose has the permission to create directories under `/data/containers` else change this path to somewhere convenient.

The Onyx container doesn't have volumes but you can adjust its settings to using a similar configuration as for Drupal.
The MySQL container should exclusively be used by Drupal installation and store only Drupal data to simplify the backup/restore process.

## Update process
To update containers code base please follow these steps: 

### Backup
Backup Drupal containers + images using this command : `make backup-drupal`

This command backs up only the Drupal instance : 
- Drupal images + volumes
- MySQL images + volumes

Basically we have to backup the binary + the data on the containers, the generated .gz files can be used to restore 
the running apps, or to deploy them in other server.

Backuping the other containers requires archiving the volumes.

To backup the image please use Drupal's script as inspiration.

Please backup periodically, especially before updating.

### Update images
Updating requires that we pull the latest image.

You can perform this command to update core drupal image code : `make update-drupal`

The new image may update the Drupal core Version but also the php and apache as it maintained by [Drupal](https://hub.docker.com/_/drupal)

In the [Obiba docker Drupal](https://hub.docker.com/repository/docker/obiba/docker-obiba-drupal) there is some .sh script 
helper to update the Obiba Drupal Modules, so inside the Drupal container you can execute this command to update to last 
Obiba Drupal modules version : `make update-obiba`

Basic Drupal steps: 
- Update Drupal images :  `make update-drupal`
- Log in Drupal container Shell : `make shell`
- Update the Obiba Drupal Modules `make update-obiba`

### Update Images with an exported images code base
On a source machine that has access to internet:
- Fire Up the containers to build a fresh container version: `make up`
- Export the base code containers : `make export-drupal`, this will generate 'export_folder/drupal_container.tar'

On target machine without internet access:
- Copy the tar file 'drupal_container.tar' to 'import_folder'
- Import the code base containers : `make import-drupal`
- Update the composer autoload : `docker exec -d obibadocker_drupal_1 make obiba-composer-conf`
- Perform Drupal update script : `docker exec -d obibadocker_drupal_1 drush updatedb`

> Make sure to backup your containers before updating them in this way. 

### Troubleshooting
In case something goes wrong with the update you can restore the backups : `make restore-drupal`
Basically this command restore the backup images + volumes of the Drupal containers.
Please feel free to adjust the script for Mica, Agate, Opal, and other containers.
