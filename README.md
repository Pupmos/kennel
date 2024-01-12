# Pupmos/kennel

![kennel](https://www.ikc.ie/wp-content/uploads/2015/05/group_of_puppies_purebred.jpg)

## What is kennel?

Kennel is a collection of the custom ansible playbooks, roles and scripts that we've put together over the past year for running and managing nodes and related services on Cosmos-based chains. Feel free to use the resources below as you see fit, based on your needs/requirements.

We predominately use [OVHCloud](https://ovhcloud.com) for our global infrastructure, with a sprinkling of services from [MEVSpace](https://mevspace.com). Some of our playbooks require a provider parameter to be passed given that both these providers provision bare metal slightly differently. If you're using a completely different provider, please raise a PR for the playbook in question as we'd like to support as many as possible.

## Registry

A registry of all Cosmos chains that can be used with our ansible playbooks. The registry contains the default configuration (such as seeds, peers, min gas fees, repository url - amongst others) for each of the chains that Kennel supports. The registry can be found [here](https://github.com/Pupmos/ansible-cosmos-registry).

## Playbooks

The Kennel ansible playbooks.

### Docker Swarm

Primarily used for running clusters of RPC/gRPC and API nodes.

| Name                   | Description                                                    | Repository                                                                                    |
|------------------------|----------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| `docker-swarm`         | Setting up a new Docker Swarm cluster.                         | [Pupmos/ansible-docker-swarm](https://github.com/Pupmos/ansible-docker-swarm)                 |
| `docker-swarm-service` | Deploying services on a Docker Swarm cluster.                  | [Pupmos/ansible-docker-swarm-service](https://github.com/Pupmos/ansible-docker-swarm-service) |

### Other

Used for running nodes on bare metal or VPS.

| Name         | Description                                                    | Repository                                                                        |
|--------------|----------------------------------------------------------------|-----------------------------------------------------------------------------------|
| `nodes`      | Setting up new Cosmos validators and RPC/gRPC/API nodes.       | [Pupmos/ansible-cosmos-nodes](https://github.com/Pupmos/ansible-cosmos-nodes)     |
| `restake`    | [restake.app](https://restake.app) on Cosmos.                  | [Pupmos/ansible-cosmos-restake](https://github.com/Pupmos/ansible-cosmos-restake) |
| `seed`       | Setting up a new Cosmos seed node.                             | [Pupmos/ansible-cosmos-seed](https://github.com/Pupmos/ansible-cosmos-seed)       |
| `ts-relayer` | Setting up [ts-relayer](https://github.com/confio/ts-relayer). | [Pupmos/ansible-ts-relayer](https://github.com/Pupmos/ansible-ts-relayer)         |

## Roles

These are not intended to be used in isolation, but rather with the playbooks above.

| Name         | Description                                                     | Repository                                                                                  |
|--------------|-----------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| `common`     | Initializing a new Cosmos full-node.                            | [Pupmos/ansible-cosmos-roles-common](https://github.com/Pupmos/ansible-cosmos-roles-common) |
| `node`       | Configuring a new Cosmos full-node.                             | [Pupmos/ansible-cosmos-roles-node](https://github.com/Pupmos/ansible-cosmos-roles-node)     |
| `rpc`        | Configuring a Cosmos full-node with public RPC/gRPC/API access. | [Pupmos/ansible-cosmos-roles-rpc](https://github.com/Pupmos/ansible-cosmos-roles-rpc)       |
| `monitoring` | For monitoring.                                                 | [Pupmos/ansible-roles-monitoring](https://github.com/Pupmos/ansible-roles-monitoring)       |

## Packages

### Auxiliary Services

| Name      | Version  | Description                                           | Package                                                             |
|-----------|----------|-------------------------------------------------------|---------------------------------------------------------------------|
| `proxy`   | `v1.0.1` | `nginx` reverse proxy for Docker Swarm clusters.      | [Download](https://github.com/Pupmos/kennel/pkgs/container/proxy)   |
| `monitor` | `v0.4.0` | DataDog Cosmos RPC monitor for Docker Swarm clusters. | [Download](https://github.com/Pupmos/kennel/pkgs/container/monitor) |

### Chains

| Chain           | Version   | DB Backend  | Package                                                                 |
|-----------------|-----------|-------------|-------------------------------------------------------------------------|
| `chihuahua-1`   | `v6.0.1`  | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/chihuahua)   |
| `cosmoshub-4`   | `v14.1.0` | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/cosmoshub)   |
| `crescent-1`    | `v4.1.1`  | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/crescent)    |
| `jackal-1`      | `v3.1.1`  | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/jackal)      |
| `juno-1`        | `v18.1.0` | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/juno)        |
| `meme-1`        | `v1.0.0`  | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/meme)        |
| `neutron-1`     | `v2.0.1`  | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/neutron)     |
| `omniflixhub-1` | `v0.12.1` | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/omniflixhub) |
| `sommelier-3`   | `v6.0.0`  | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/sommelier)   |
| `stargaze-1`    | `v12.2.0` | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/stargaze)    |
| `stride-1`      | `v16.0.0` | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/stride)      |
| `teritori-1`    | `v1.4.0`  | `goleveldb` | [Download](https://github.com/Pupmos/kennel/pkgs/container/teritori)    |

## TODO

* Akash support.
* Dynamic hostnames in `docker/proxy/nginx.conf`.
* Upgrade all docker images to PebbleDB.

## Acknowledgements/Credits

- Inspired by [Cosmosia](https://github.com/notional-labs/cosmosia) from the great team over at [Notional](https://notional.ventures). 
