FROM rust:1.69.0-alpine AS builder

COPY . /project

RUN apk add --no-cache musl-dev openssl-dev
RUN cargo install --path "/project/backend/aggregator" --target-dir "/project/target"
RUN apk add --no-cache bash

FROM alpine

COPY --from=builder /project/target/release/aggregator /usr/local/bin

ENTRYPOINT ["/usr/local/bin/aggregator"]
