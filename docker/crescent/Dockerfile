FROM golang:1.18-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Crescent
FROM golang:1.18-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /crescent

RUN git clone --branch v4.0.0 https://github.com/crescent-network/crescent .

RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LDFLAGS='-linkmode=external -extldflags "-Wl,-z,muldefs -static"' make build

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /crescent/build/crescentd /usr/bin/crescentd

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
