#!/bin/bash

set -xeo pipefail

ROOT="$PWD"

cd "$ROOT/frontend/client"
npm install
npm run build

cd "$ROOT/frontend/admin"
npm install
npm run build

cd "$ROOT"
if [ -d "$ROOT/dist" ]; then
	rm -R "$ROOT/dist"
fi
mkdir "$ROOT/dist"
cp -r "$ROOT/frontend/admin/dist/"* "$ROOT/dist"
mkdir "$ROOT/dist/client"
cp -r "$ROOT/frontend/client/dist/"* "$ROOT/dist/client"
