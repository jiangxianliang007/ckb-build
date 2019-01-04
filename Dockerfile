FROM rust:1.31.0
LABEL description="Nervos CKB is a public permissionless blockchain, the common knowledge layer of Nervos network."
LABEL maintainer="Nervos Core Dev <dev@nervos.org>"

RUN apt-get update && apt-get install -y \
git \
autoconf \
flex bison \
texinfo \
libtool \
pkg-config \
libssl-dev \
libclang-dev \
libsqlite3-dev \
&& apt-get autoremove \
&& apt-get clean \
&& apt-get autoclean

RUN rustup component add rustfmt && rustup component add clippy

RUN ln -s /usr/lib/gcc/x86_64-linux-gnu/6/include/stdarg.h /usr/include/stdarg.h && ln -s /usr/lib/gcc/x86_64-linux-gnu/6/include/stddef.h /usr/include/stddef.h
