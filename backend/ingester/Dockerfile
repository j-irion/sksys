FROM rust:1.69.0 AS builder

ENV CARGO_HOME=/project/.cache/cargo

COPY . /project
WORKDIR /project
RUN env CARGO_HOME=/project/.cache/cargo cargo build --release -p ingester

FROM node AS admin-builder

COPY ./frontend/admin /project 
WORKDIR /project
RUN npm install
RUN npm run build

FROM node AS client-builder

COPY ./frontend/client /project
WORKDIR /project
RUN npm install
RUN npm run build

FROM debian:bullseye

COPY --from=admin-builder /project/dist /dist
COPY --from=client-builder /project/dist /dist/client
COPY --from=builder /project/target/release/ingester /usr/local/bin
RUN apt-get update && apt-get install -y ca-certificates openssl

ENTRYPOINT ["/usr/local/bin/ingester"]
