# Use a base image with the latest version of Rust installed
FROM rust:latest as builder

ARG CRATE_NAME=docker_py_rs_so_example

# Set the working directory in the container
WORKDIR /app

# Install the linux-musl build target
RUN rustup target add x86_64-unknown-linux-musl

# Create a blank project
RUN cargo init --lib

# Copy only the dependencies
COPY Cargo.toml Cargo.lock ./

# A dummy build to get the dependencies compiled and cached
RUN cargo build --target x86_64-unknown-linux-musl --release

# Copy the real library code into the container
COPY . .

# Build the library
RUN cargo build --target x86_64-unknown-linux-musl --release

# Note: stripping the .so file caused an error when loading it in python

# Use a slim image for running the library
FROM alpine as runtime

# Using gcompat is almost certainly a hack, but it works
RUN apk add gcompat

# Install python3 (without pip)
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
# RUN python3 -m ensurepip
# RUN pip3 install --no-cache --upgrade pip setuptools

COPY call_rust.py call_rust.py

ARG OUTLIB=libexample.so

# Copy only the compiled binary from the builder stage to this image
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/*.so $OUTLIB

ENV OUTLIB=$OUTLIB

# CMD ls
CMD python3 call_rust.py ./$OUTLIB
