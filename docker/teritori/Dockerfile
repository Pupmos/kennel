# Cosmovisor
FROM golang:1.21-alpine3.17 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Teritori
FROM golang:1.21-alpine3.17 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /teritori

ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.3.1/libwasmvm_muslc.aarch64.a /lib/libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.3.1/libwasmvm_muslc.x86_64.a /lib/libwasmvm_muslc.x86_64.a
RUN sha256sum /lib/libwasmvm_muslc.aarch64.a | grep 9f5f387bddbd51a549f2d8eb2cc0f08030f311610c43004b96c141a733b681bc
RUN sha256sum /lib/libwasmvm_muslc.x86_64.a | grep 129da0e50eaa3da093eb84c3a8f48da20b9573f3afdf83159b3984208c8ec5c3

RUN cp "/lib/libwasmvm_muslc.$(uname -m).a" /lib/libwasmvm_muslc.a

RUN git clone --branch v2.0.6 https://github.com/TERITORI/teritori-chain .

RUN LEDGER_ENABLED=false BUILD_TAGS=muslc LDFLAGS='-linkmode=external -extldflags "-Wl,-z,muldefs -static"' make build

# Main.
FROM alpine:3.16

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /teritori/build/teritorid /usr/bin/teritorid

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
