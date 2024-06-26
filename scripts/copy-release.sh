#!/bin/sh

set -e

echo $(pwd)

APP_NAME=nuca_backend
APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2 | tail -1)"

echo $APP_NAME
echo $APP_VSN

ssh nuca_server "mkdir -p /opt/crafting/$APP_NAME/$APP_VSN"
scp -i ~/.ssh/nuca-backend.pem rel/artifacts/"prod-$APP_NAME-$APP_VSN.tar.gz" ubuntu@ec2-3-249-211-184.eu-west-1.compute.amazonaws.com:/opt/crafting/$APP_NAME/"$APP_VSN"/"$APP_NAME-$APP_VSN.tar.gz"
ssh nuca_server  "cd /opt/crafting/$APP_NAME/$APP_VSN && tar xvf $APP_NAME-$APP_VSN.tar.gz && rm -r $APP_NAME-$APP_VSN.tar.gz"
