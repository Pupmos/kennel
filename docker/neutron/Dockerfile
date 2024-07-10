FROM golang:1.22-alpine3.19 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Neutron
FROM golang:1.22-alpine3.19 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /neutron

RUN git clone --branch v4.0.1 https://github.com/neutron-org/neutron .

RUN set -eux; \
    WASMVM_VERSION=$(go list -m github.com/CosmWasm/wasmvm/v2 | cut -d ' ' -f 2) && \
    wget https://github.com/CosmWasm/wasmvm/releases/download/${WASMVM_VERSION}/libwasmvm_muslc.$(uname -m).a \
      -O /lib/libwasmvm_muslc.$(uname -m).a && \
      go mod download;

ENV LD_FLAGS="-X github.com/cosmos/cosmos-sdk/version.Name=neutron \
    -X github.com/cosmos/cosmos-sdk/version.AppName=neutrond \
    -X github.com/cosmos/cosmos-sdk/version.Version=v4.0.1 \
    -X github.com/cosmos/cosmos-sdk/version.BuildTags=muslc"

RUN go install -tags "muslc" -ldflags "-w -s ${LD_FLAGS} -linkmode=external -extldflags '-Wl,-z,muldefs -static'" ./...

# Main.
FROM alpine:3.16

RUN apk add git make curl wget vim jq lz4

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/neutrond /usr/bin/neutrond

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
