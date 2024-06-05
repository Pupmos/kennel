# Cosmovisor
FROM golang:1.21-alpine3.19 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Gaia
FROM golang:1.21-alpine3.19 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /cosmoshub

RUN git clone --branch v17.1.0 https://github.com/cosmos/gaia .

RUN CGO_ENABLED=0 make install

# Main.
FROM alpine:3.19

RUN apk add git make curl wget vim jq lz4

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /go/bin/gaiad /usr/bin/gaiad

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
