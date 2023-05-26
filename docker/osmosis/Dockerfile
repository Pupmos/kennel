# Cosmovisor
FROM golang:1.19-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Osmosis
FROM golang:1.19-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed musl-dev gcc libc-dev

WORKDIR /osmosis

RUN git clone --branch v15.1.2 https://github.com/osmosis-labs/osmosis .

RUN set -eux; \
    export ARCH=$(uname -m); \
    wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/v1.1.2/libwasmvm_muslc.${ARCH}.a; \
    go mod download;

RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LDFLAGS='-linkmode=external -extldflags "-Wl,-z,muldefs -static"' make build

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /osmosis/build/osmosisd /usr/bin/osmosisd

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
