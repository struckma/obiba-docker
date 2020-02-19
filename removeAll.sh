#!/usr/bin/env bash

echo "Please enable me first"
exit 1

# stop all container & purge drupal container
make down

# remove all images
docker image prune -a -f

# delete volumes folders
rm -rfv ./volumes/data
