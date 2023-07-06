FROM debian

COPY ./target/release/aggregator /usr/local/bin
RUN apt-get update && apt-get install -y ca-certificates openssl

ENTRYPOINT ["/usr/local/bin/aggregator"]
