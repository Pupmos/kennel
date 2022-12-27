# Cosmovisor
FROM golang:1.19-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Joe
FROM golang:1.19-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /joe

ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.1.1/libwasmvm_muslc.aarch64.a /lib/libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.1.1/libwasmvm_muslc.x86_64.a /lib/libwasmvm_muslc.x86_64.a
RUN sha256sum /lib/libwasmvm_muslc.aarch64.a | grep 9ecb037336bd56076573dc18c26631a9d2099a7f2b40dc04b6cae31ffb4c8f9a
RUN sha256sum /lib/libwasmvm_muslc.x86_64.a | grep 6e4de7ba9bad4ae9679c7f9ecf7e283dd0160e71567c6a7be6ae47c81ebe7f32

RUN cp "/lib/libwasmvm_muslc.$(uname -m).a" /lib/libwasmvm_muslc.a

RUN git clone --branch v0.0.2 https://github.com/joe-chain/joe .

RUN go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble && \
    go mod tidy

ENV LD_FLAGS="-X github.com/cosmos/cosmos-sdk/version.Name=joe \
    -X github.com/cosmos/cosmos-sdk/version.AppName=joed \
    -X github.com/cosmos/cosmos-sdk/version.Version=v0.0.2 \
    -X github.com/cosmos/cosmos-sdk/version.BuildTags=muslc \
    -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb"

RUN go install -tags "pebbledb,muslc" -ldflags "-w -s ${LD_FLAGS} -linkmode=external -extldflags '-Wl,-z,muldefs -static'" ./...

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/joed /usr/bin/joed

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
