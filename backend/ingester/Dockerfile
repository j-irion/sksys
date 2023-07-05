FROM rust:1.69.0 AS builder

ENV CARGO_HOME=/project/.cache/cargo

COPY . /project
WORKDIR /project
RUN env CARGO_HOME=/project/.cache/cargo cargo build --release -p ingester

FROM debian:bullseye

COPY ./dist /dist
COPY --from=builder /project/target/release/ingester /usr/local/bin
RUN apt-get update && apt-get install -y ca-certificates openssl

ENTRYPOINT ["/usr/local/bin/ingester"]
