FROM golang:1.18-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Sommelier
FROM golang:1.18-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /sommelier

RUN git clone --branch v6.0.0 https://github.com/PeggyJV/sommelier .

ENV LD_FLAGS="-X github.com/cosmos/cosmos-sdk/version.Name=sommelier \
    -X github.com/cosmos/cosmos-sdk/version.AppName=sommelier \
    -X github.com/cosmos/cosmos-sdk/version.Version=v6.0.0 \
    -X github.com/cosmos/cosmos-sdk/version.BuildTags=muslc"

RUN go install -tags "muslc" -ldflags "-w -s ${LD_FLAGS} -linkmode=external -extldflags '-Wl,-z,muldefs -static'" ./...

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/sommelier /usr/bin/sommelier

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
