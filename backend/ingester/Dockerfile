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

FROM debian

COPY --from=admin-builder /project/dist /dist
COPY --from=client-builder /project/dist /dist/client
COPY ./target/release/ingester /usr/local/bin
RUN apt-get update && apt-get install -y ca-certificates openssl

ENTRYPOINT ["/usr/local/bin/ingester"]
