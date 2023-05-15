FROM golang:1.19-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Omniflix
FROM golang:1.19-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /omniflix

RUN git clone --branch v0.10.0 https://github.com/OmniFlix/omniflixhub .

ENV LD_FLAGS="-X github.com/cosmos/cosmos-sdk/version.Name=omniflixhub \
    -X github.com/cosmos/cosmos-sdk/version.AppName=omniflixhubd \
    -X github.com/cosmos/cosmos-sdk/version.Version=v0.10.0"

RUN go install -ldflags "-w -s ${LD_FLAGS} -linkmode=external -extldflags '-Wl,-z,muldefs -static'" ./...

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/omniflixhubd /usr/bin/omniflixhubd

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
