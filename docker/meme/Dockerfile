# Cosmovisor
FROM golang:1.17-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Meme
FROM golang:1.17-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /meme

ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.0.0-beta10/libwasmvm_muslc.aarch64.a /lib/libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.0.0-beta10/libwasmvm_muslc.x86_64.a /lib/libwasmvm_muslc.x86_64.a
RUN sha256sum /lib/libwasmvm_muslc.aarch64.a | grep 5b7abfdd307568f5339e2bea1523a6aa767cf57d6a8c72bc813476d790918e44
RUN sha256sum /lib/libwasmvm_muslc.x86_64.a | grep 2f44efa9c6c1cda138bd1f46d8d53c5ebfe1f4a53cf3457b01db86472c4917ac

RUN cp "/lib/libwasmvm_muslc.$(uname -m).a" /lib/libwasmvm_muslc.a

RUN git clone --branch v1.0.0 https://github.com/memecosmos/meme .

RUN go mod edit -replace github.com/tendermint/tm-db=github.com/baabeetaa/tm-db@pebble && \
    go mod tidy

ENV LD_FLAGS="-X github.com/cosmos/cosmos-sdk/version.Name=meme \
    -X github.com/cosmos/cosmos-sdk/version.AppName=memed \
    -X github.com/cosmos/cosmos-sdk/version.Version=v1.0.0 \
    -X github.com/cosmos/cosmos-sdk/version.BuildTags=muslc"

RUN go install -tags "muslc" -ldflags "-w -s ${LD_FLAGS} -linkmode=external -extldflags '-Wl,-z,muldefs -static'" ./...

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/memed /usr/bin/memed

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
