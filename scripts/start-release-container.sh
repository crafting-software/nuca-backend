#!/bin/sh
set -e

docker build -t nuca-release-machine . --file=Dockerfile --network=host && docker run --network "host" -v $(pwd):/opt/crafting/nuca-backend -it nuca-release-machine
