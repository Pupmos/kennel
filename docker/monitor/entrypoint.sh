#!/bin/bash
# Entrypoint.

TASKS=(chihuahua cosmoshub crescent jackal joe juno meme omniflixhub osmosis sommelier stargaze stride teritori)

# Run.
run() {
  for i in "${TASKS[@]}"
  do
    # shellcheck disable=SC2016
    ADDRS=$(host -t a tasks."${i}" | awk '{ print $4 }' | xargs)

    printf '> Checking %s...\n' "${i}"

    for j in $ADDRS; do
      moniker=$(curl -s "http://${j}:26657/status" | jq -r '.result.node_info.moniker' | xargs)
      printf '>  Got moniker %s...\n' "${moniker}"

      printf '>  Checking block latency...'
      TAG="${moniker}" RPC_STATUS_URL="http://${j}:26657/status" make block-latency -C /usr/src/datadog --no-print-directory
      printf '\n>  Checking block peers...'
      TAG="${moniker}" RPC_NET_INFO_URL="http://${j}:26657/net_info" make peers -C /usr/src/datadog --no-print-directory
    done

    printf '\n> DONE\n\n'
  done
}

# Loop.
while true; do
  if [ -z "${DD_API_KEY}" ]; then
    printf 'DD_API_KEY is not set!'
    exit 1
  fi

  run

  sleep 60
done
