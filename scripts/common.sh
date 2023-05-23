# Common.

# Init
chain_init() {
  printf "> Initialize..."
  "${BINARY}" init rpc --chain-id "${CHAIN_ID}" --overwrite > /dev/null 2>&1
  printf "DONE\n"
}

# Download genesis.
genesis_download() {
  printf "> Download genesis..."
  wget -P "${HOME}"/"${ROOT}"/config "${GENESIS_URL}" > /dev/null 2>&1
  printf "DONE\n"
}

# Unpack genesis.
genesis_unpack() {
  printf "> Unpack genesis..."
  gunzip -c "${HOME}"/"${ROOT}"/config/genesis.json.gz > "${HOME}"/"${ROOT}"/config/genesis.json
  printf "DONE\n"
}

# Setup cosmovisor.
cosmovisor_setup() {
  printf "> Setup cosmovisor..."
  cat <<EOF > "${HOME}"/.profile
export DAEMON_HOME=${HOME}/${ROOT}
export DAEMON_RESTART_AFTER_UPGRADE=true
export DAEMON_ALLOW_DOWNLOAD_BINARIES=false
export DAEMON_NAME=${BINARY}
export DAEMON_LOG_BUFFER_SIZE=512
export UNSAFE_SKIP_BACKUP=true
export PERSISTENT_PEERS=${PERSISTENT_PEERS}
export SEEDS=${SEEDS}
EOF

  mkdir -p "${HOME}"/"${ROOT}"/cosmovisor/genesis/bin
  mkdir -p "${HOME}"/"${ROOT}"/cosmovisor/upgrades

  if [ -z "${UPGRADE}" ]; then
    cp $(which "${BINARY}") "${HOME}"/"${ROOT}"/cosmovisor/genesis/bin
  fi
  printf "DONE\n"
}

# Cosmovisor upgrades.
cosmovisor_upgrades() {
  printf "> Upgrade..."
  # Copy the binary to the correct location.
  if [ -n "${UPGRADE}" ]; then
    mkdir -p "${HOME}"/"${ROOT}"/cosmovisor/upgrades/"${UPGRADE}"/bin
    cp $(which "${BINARY}") "${HOME}"/"${ROOT}"/cosmovisor/upgrades/"${UPGRADE}"/bin
  fi

  if [ -n "${UPDATE_SYMLINK}" ]; then
    if [ -d "${HOME}"/"${ROOT}"/cosmovisor/current ]; then
      rm "${HOME}"/"${ROOT}"/cosmovisor/current
    fi
    ln -s "${HOME}"/"${ROOT}"/cosmovisor/upgrades/"${UPGRADE}" "${HOME}"/"${ROOT}"/cosmovisor/current
  fi
  printf "DONE\n"
}

# Update config.
config_update() {
  printf "> Update config..."

  if [ ! -f "${HOME}"/"${ROOT}"/config/app.toml ]; then
    printf "\n\tERROR: app.toml not found!\n"
    exit 1
  fi

  # app.toml
  sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"${MINIMUM_GAS_PRICES}\"/" "${HOME}"/"${ROOT}"/config/app.toml
  sed -i '/^\[api]/,/^\[/{s/^enable[[:space:]]*=.*/enable = true/}' "${HOME}"/"${ROOT}"/config/app.toml
  sed -i '/^\[grpc]/,/^\[/{s/^address[[:space:]]*=.*/address = "0.0.0.0:9090"/}' "${HOME}"/"${ROOT}"/config/app.toml
  sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" "${HOME}"/"${ROOT}"/config/app.toml
  sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"181440\"/" "${HOME}"/"${ROOT}"/config/app.toml
  sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" "${HOME}"/"${ROOT}"/config/app.toml
  sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"100\"/" "${HOME}"/"${ROOT}"/config/app.toml
  sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = 0/" "${HOME}"/"${ROOT}"/config/app.toml
  sed -i -e "s/^swagger *=.*/swagger = true/" "${HOME}"/"${ROOT}"/config/app.toml

  if [ ! -f "${HOME}"/"${ROOT}"/config/config.toml ]; then
    printf "\n\tERROR: config.toml not found!\n"
    exit 1
  fi

  # config.toml
  sed -i '/^\[rpc]/,/^\[/{s/^laddr[[:space:]]*=.*/laddr = "tcp:\/\/0.0.0.0:26657"/}' "${HOME}"/"${ROOT}"/config/config.toml
  sed -i -e "s/^max_num_inbound_peers *=.*/max_num_inbound_peers = 1000/" "${HOME}"/"${ROOT}"/config/config.toml
  sed -i -e "s/^max_num_outbound_peers *=.*/max_num_outbound_peers = 200/" "${HOME}"/"${ROOT}"/config/config.toml
  sed -i -e "s/^log_level *=.*/log_level = \"error\"/" "${HOME}"/"${ROOT}"/config/config.toml
  sed -i -e "s/^db_backend *=.*/db_backend = \"${DB_BACKEND}\"/" "${HOME}"/"${ROOT}"/config/config.toml
  printf "DONE\n"
}

# Download snapshot.
snapshot_download() {
  printf "> Download snapshot..."
  if [ -n "${SNAPSHOT_URL}" ]; then
    wget -O "${HOME}"/"${ROOT}"/snapshot."${SNAPSHOT_TYPE}" "${SNAPSHOT_URL}" > /dev/null 2>&1
  fi
  printf "DONE\n"
}

# Unpack snapshot.
snapshot_unpack() {
  printf "> Unpack snapshot..."
  rm -rf "${HOME}"/"${ROOT}"/data
  if [ "${SNAPSHOT_TYPE}" == "tar.lz4" ]; then
    lz4 -c -d "${HOME}"/"${ROOT}"/snapshot."${SNAPSHOT_TYPE}" | tar -x -C "${HOME}"/"${ROOT}"
  elif [ "${SNAPSHOT_TYPE}" == "tar.gz" ] || [ "${SNAPSHOT_TYPE}" == "tgz" ]; then
    tar -zxf "${HOME}"/"${ROOT}"/snapshot."${SNAPSHOT_TYPE}" -C "${HOME}"/"${ROOT}"
  fi

  rm "${HOME}"/"${ROOT}"/snapshot."${SNAPSHOT_TYPE}"
  printf "DONE\n"
}

# State-sync setup.
state_sync_setup() {
  printf "> State-sync setup..."
  latest_height=$(curl -s "${STATE_SYNC_HOST}"/block | jq -r .result.block.header.height)
  trust_height=$((latest_height - 2000))
  trust_hash=$(curl -s "${STATE_SYNC_HOST}/block?height=${trust_height}" | jq -r .result.block_id.hash)

  sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
  s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$STATE_SYNC_HOST,$STATE_SYNC_HOST\"| ; \
  s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$trust_height| ; \
  s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$trust_hash\"|" "${HOME}"/"${ROOT}"/config/config.toml

  printf "DONE\n"
}

# Download the latest address book
address_book_download() {
  if [ -n "${ADDRESS_BOOK_URL}" ]; then
    printf "> Download address book..."
    if [ -f "${HOME}"/"${ROOT}"/config/addrbook.json ]; then
      rm "${HOME}"/"${ROOT}"/config/addrbook.json
    fi

    wget -q -O "${HOME}"/"${ROOT}"/config/addrbook.json "${ADDRESS_BOOK_URL}"
    printf "DONE\n"
  fi
}

# Pre-flight checks.
pre_flight() {
  printf "> Pre-flight checks..."
  if [ ! -f "${HOME}"/"${ROOT}"/data/priv_validator_state.json ]; then
    cat <<EOF > "${HOME}"/"${ROOT}"/data/priv_validator_state.json
{
  "height": "0",
  "round": 0,
  "step": 0
}
EOF
  fi
  printf "DONE\n"
}

# Start
node_start() {
  printf "> Dumping ENV...\n"
  env
  printf "> Start node...\n"
  source "${HOME}"/.profile

  if [ -n "${SEEDS}" ] && [ -n "${PERSISTENT_PEERS}" ]; then
    cosmovisor start --moniker $(hostname) --p2p.seeds="${SEEDS}" --p2p.persistent_peers="${PERSISTENT_PEERS}" --log_format json
  elif [ -n "${SEEDS}" ] && [ -z "${PERSISTENT_PEERS}" ]; then
    cosmovisor start --moniker $(hostname) --p2p.seeds="${SEEDS}" --log_format json
  elif [ -z "${SEEDS}" ] && [ -n "${PERSISTENT_PEERS}" ]; then
    cosmovisor start --moniker $(hostname) --p2p.persistent_peers="${PERSISTENT_PEERS}" --log_format json
  fi
}
