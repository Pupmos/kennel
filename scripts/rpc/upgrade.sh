#!/bin/sh
# Upgrade an existing RPC node.

. $(dirname "${0}")/../common.sh

# Check vars.
check_vars() {
  if [ -z "${BINARY}" ]; then
    printf "BINARY is not set!\n"
    exit 1
  fi

  if [ -z "${ROOT}" ]; then
    printf "ROOT is not set!\n"
    exit 1
  fi

  if [ -z "${UPGRADE}" ]; then
    printf "UPGRADE is not set!\n"
    exit 1
  fi
}

check_vars

# Cosmovisor.
cosmovisor_upgrades

# Start
node_start