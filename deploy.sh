#!/bin/bash

export MIX_ENV=prod mix compile
export PORT=4797
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mkdir -p ~/.config
mkdir -p priv/static

source .google.env

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production && cd ..)
mix phx.digest

echo "Generating release..."
mix release

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/draw/bin/practice stop || true

echo "Starting app..."

_build/prod/rel/project2/bin/project2 foreground

