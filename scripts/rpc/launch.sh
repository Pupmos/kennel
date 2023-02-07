#!/bin/sh
# Launch a new RPC node.

. $(dirname "${0}")/../common.sh

# Check vars.
check_vars() {
  if [ -z "${CHAIN_ID}" ]; then
    printf "CHAIN_ID is not set!\n"
    exit 1
  fi

  if [ -z "${BINARY}" ]; then
    printf "BINARY is not set!\n"
    exit 1
  fi

  if [ -z "${CHAIN_ID}" ]; then
    printf "CHAIN_ID is not set!\n"
    exit 1
  fi

  if [ -z "${ROOT}" ]; then
    printf "ROOT is not set!\n"
    exit 1
  fi

  if [ -z "${GENESIS_URL}" ]; then
    printf "GENESIS_URL is not set!\n"
    exit 1
  fi

  if [ -z "${SEEDS}" ] && [ -z "${PERSISTENT_PEERS}" ]; then
    printf "SEEDS _or_ PERSISTENT_PEERS must be set!\n"
    exit 1
  fi

  if [ -z "${MINIMUM_GAS_PRICES}" ]; then
    printf "MINIMUM_GAS_PRICES is not set!\n"
    exit 1
  fi
}

check_vars

# Assume that if the root exists, then this node has already been setup.
if [ ! -d "${HOME}"/"${ROOT}" ]; then
  clear

  # Init.
  chain_init

  # Genesis.
  genesis_download
  genesis_unpack

  # Cosmovisor.
  if [ -n "${UPGRADE}" ]; then
    UPDATE_SYMLINK=true
  fi
  cosmovisor_setup
  cosmovisor_upgrades

  # Config.
  config_update

  # State-sync, snapshot or genesis?
  if [ -n "${STATE_SYNC_HOST}" ]; then
    state_sync_setup
  elif [ -n "${SNAPSHOT_URL}" ] && [ -n "${SNAPSHOT_TYPE}" ]; then
    snapshot_download
    snapshot_unpack
  fi
fi

# Address book
address_book_download

# Start.
node_start
