FROM rust:1.69.0 AS builder

COPY . /project

RUN cargo install --path "/project/backend/aggregator" --target-dir "/project/target"

FROM debian

COPY --from=builder /project/target/release/aggregator /usr/local/bin
RUN apt-get update && apt-get install -y ca-certificates

ENTRYPOINT ["/usr/local/bin/aggregator"]
