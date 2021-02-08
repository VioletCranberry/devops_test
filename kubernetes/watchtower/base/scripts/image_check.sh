#!/bin/bash

function get_sha_local() {
  local repo="$1" result
  result="$(kubectl get pods --namespace default -o json | `
  `jq -r ".items[] .status.containerStatuses[] | select(.imageID | contains(\"${repo}\")) | .imageID" | sort -u)"
  echo "$result" | awk -F '@' '{ print $2 }'
}

function get_sha_remote() {
  local repo="$1" region="$2" result
  result="$(aws ecr describe-images --repository-name "$repo" --region "$region" | `
  `jq -r '.imageDetails[-1] .imageDigest')"
  echo "$result"
}

function main() {

  local repo='internal-ervcp_repo' region='eu-central-1'
  local deployment='ervcp'

  if [ "$(get_sha_local "$repo")" != "$(get_sha_remote "$repo" "$region")" ]; then
    echo "new image available"
    kubectl rollout restart deployment "$deployment"
  else
    echo "no new image available"
  fi;
}

main
