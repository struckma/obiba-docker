#!/usr/bin/env bash


# stop all container & purge drupal container
make docker-clear-all

# remove all images
docker image prune -a -f

# delete volumes folders
rm -rfv /data/containers