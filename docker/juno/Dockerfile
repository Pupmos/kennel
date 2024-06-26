# Cosmovisor
FROM golang:1.22-alpine AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Juno
FROM golang:1.22-alpine AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /juno

RUN git clone --branch v22.0.1 https://github.com/CosmosContracts/juno .

RUN set -eux; \
    export ARCH=$(uname -m); \
    WASM_VERSION=$(go list -m all | grep github.com/CosmWasm/wasmvm | awk '{print $2}'); \
    if [ ! -z "${WASM_VERSION}" ]; then \
      wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.${ARCH}.a; \
    fi; \
    go mod download;

RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LINK_STATICALLY=true make build

# Main.
FROM alpine:latest

RUN apk add git make curl wget vim jq lz4

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /juno/bin/junod /usr/bin/junod

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
