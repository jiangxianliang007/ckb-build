FROM rust:1.73.0-buster
LABEL description="Nervos CKB is a public permissionless blockchain, the common knowledge layer of Nervos network."
LABEL maintainer="Nervos Core Dev <dev@nervos.org>"

RUN apt-get update && apt-get install -y \
git \
&& apt-get autoremove \
&& apt-get clean \
&& apt-get autoclean

RUN rustup component add rustfmt && rustup component add clippy
