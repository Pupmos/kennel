#!/bin/bash
# Entrypoint.

TASKS=(chihuahua-1-1 cosmoshub-4-1 cosmoshub-4-2 crescent jackal-1-1 juno-1-1 juno-1-2 meme-1-1 osmosis-1-1 osmosis-1-2 sommelier-3-1 stargaze-1-1 stride-1-1 teritori-1-1)

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
