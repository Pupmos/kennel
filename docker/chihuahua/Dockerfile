# Cosmovisor
FROM golang:1.19-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Chihuahua
FROM golang:1.19-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /chihuahua

RUN git clone --branch v4.2.3 https://github.com/ChihuahuaChain/chihuahua .

RUN set -eux; \
    export ARCH=$(uname -m); \
    WASM_VERSION=$(go list -m all | grep github.com/CosmWasm/wasmvm | awk '{print $2}'); \
    if [ ! -z "${WASM_VERSION}" ]; then \
      wget -O /lib/libwasmvm_muslc.a https://github.com/CosmWasm/wasmvm/releases/download/${WASM_VERSION}/libwasmvm_muslc.${ARCH}.a; \
    fi; \
    go mod download;

ENV LD_FLAGS="-X github.com/cosmos/cosmos-sdk/version.Name=chihuahua \
    -X github.com/cosmos/cosmos-sdk/version.AppName=chihuahuad \
    -X github.com/cosmos/cosmos-sdk/version.Version=v4.2.3 \
    -X github.com/cosmos/cosmos-sdk/version.BuildTags=muslc"

RUN go install -tags "muslc" -ldflags "-w -s ${LD_FLAGS} -linkmode=external -extldflags '-Wl,-z,muldefs -static'" ./...

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/chihuahuad /usr/bin/chihuahuad

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
