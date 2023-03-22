#!/bin/bash
set -e
set -x


cd $(dirname "$0")/assets

npm install

npx -y -i browserslist@latest
npx browserslist --update-db
npm run deploy
