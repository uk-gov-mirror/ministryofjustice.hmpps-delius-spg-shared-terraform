#!/bin/sh
set -e
docker system prune -a -f
echo "-> Image cleanup success"