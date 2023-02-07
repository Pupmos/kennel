# Cosmovisor
FROM golang:1.18-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Gaia
FROM golang:1.18-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /cosmoshub

RUN git clone --branch v7.1.0 https://github.com/cosmos/gaia .

ENV LD_FLAGS="-X github.com/cosmos/cosmos-sdk/version.Name=gaia \
    -X github.com/cosmos/cosmos-sdk/version.AppName=gaiad \
    -X github.com/cosmos/cosmos-sdk/version.Version=v7.1.0 \
    -X github.com/cosmos/cosmos-sdk/version.BuildTags=muslc"

RUN go install -tags "muslc" -ldflags "-w -s ${LD_FLAGS} -linkmode=external -extldflags '-Wl,-z,muldefs -static'" ./...

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/gaiad /usr/bin/gaiad

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
