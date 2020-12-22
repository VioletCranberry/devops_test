#!/bin/bash

ERVCP_DB_HOST='redis'
ERVCP_DB_PORT=6379

ERVCP_PORT=8080

function url_test() {
  local status_code
  status_code=$(curl --write-out '%{http_code}'`
  ` --silent --output /dev/null `
  `"localhost:$ERVCP_PORT$1")
  echo "$status_code"
}

function key_test() {
  local key="$1"
  local value 
  value="$(sed -n '$p' <<< "$(echo "GET $key" | `
  `nc "$ERVCP_DB_HOST" "$ERVCP_DB_PORT" -q 1)")"
  echo "$value"
}

for url in '/' '/health' '/assets/'; do
  status_code=$(url_test "$url")
  echo "[$url]:[$status_code]"
  if [ "$status_code" != '200' ]; then
    exit 1; fi
done

for key in 'count'; do
  value=$(key_test "$key")
  echo "[$key]:[$value]"
  if [ "$value" == 0 ]; then
    exit 1; fi
done
