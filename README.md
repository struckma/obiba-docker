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
Please take a look to the Makefile that define some basic command to manage the Obiba docker containers, enter make -help for more informations 

## Volumes location
The volumes are stored on these folders :
 
* Drupal : in the default docker volumes location : /var/lib/docker/volumes/obibadocker_drupal_sites/_data/
* Mica : /data/containers/mica_srv
* Opal : /data/containers/opal_srv
* Agate : /data/containers/agate_srv
* Mongo :  /data/containers/mongo_configdb  and /data/containers/mongo_db
* mysql : /data/containers/mysql_db

The Onyx and the R-server container haven't volumes you can adjust this as you needs
The mysql container should exclusively be used by Drupal installation and ave to store only drupal data

## Update process
To update containers code base please follow these steps: 

### Backup
Backup Drupal containers + images using this command : # make backup-drupal
This command backup only the Drupal instance : 
- Drupal images + volumes
- Mysql images + volumes
Basically we have to backup the code + the data on the containers, the generated .gz files can be used to restore 
the running apps, or to deploy them in other server for example
Please feel free to adjust the scripts to backup all containers 

### Update images
In a normal update images containers process we don't have to carry about volumes of the containers, we have to pull the
last images code base version, 
You can perform this command to update core drupal image code : # make update-drupal
The new image may update the Drupal core Version but also the Used php amd apache as it maintained by [Drupal](https://hub.docker.com/_/drupal)
In the [Obiba docker Drupal](https://hub.docker.com/repository/docker/obiba/docker-obiba-drupal) there is some .sh script 
helper to update the Obiba Drupal Modules, so inside the Drupal container you can execute this command to update to last 
Obiba Drupal modules version : # make update-obiba 

Basic steps: 
- Update Drupal images :  # make update-drupal
- Log in Drupal container Shell : # make shell
- Update the Obiba Drupal Modules # make update-obiba   

### Troubleshooting
In case something goes wrong with the update you can restore the backups : # make restore-drupal
Basically this command restore the backup images + volumes of the drupal containers
Please feel free to adjust the script for mica, agate Opal, .. etc containers

   


