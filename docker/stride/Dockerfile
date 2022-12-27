# Cosmovisor
FROM golang:1.19-alpine3.15 AS cosmovisor

RUN go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

# Stride
FROM golang:1.19-alpine3.15 AS build

RUN apk add --no-cache ca-certificates build-base git sed

WORKDIR /stride

RUN git clone --branch v4.0.2 https://github.com/Stride-Labs/stride .

RUN make build

# Main.
FROM alpine:3.15

RUN apk add git make curl wget vim jq lz4 busybox-initscripts

COPY --from=cosmovisor /go/bin/cosmovisor /usr/bin/cosmovisor
COPY --from=build /stride/build/strided /usr/bin/strided

EXPOSE 1317
EXPOSE 9090
EXPOSE 26656
EXPOSE 26657
