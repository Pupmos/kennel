# Cosmovisor
FROM golang:1.21-alpine3.19 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Stride
FROM golang:1.21-alpine3.19 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /stride

RUN git clone --branch v22.0.0 https://github.com/Stride-Labs/stride .

RUN WASMVM_VERSION=$(cat go.mod | grep github.com/CosmWasm/wasmvm | awk '{print $2}') \
    && wget https://github.com/CosmWasm/wasmvm/releases/download/$WASMVM_VERSION/libwasmvm_muslc.$(uname -m).a \
    -O /lib/libwasmvm_muslc.a

RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LINK_STATICALLY=true make build

# Main.
FROM alpine:3.19

RUN apk add git make curl wget vim jq lz4

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /stride/build/strided /usr/bin/strided

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
