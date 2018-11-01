#!/usr/bin/env bash
docker system prune -a -f
exit_on_error $? !!
echo "-> Image cleanup success"