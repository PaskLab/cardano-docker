FROM lukemathwalker/cargo-chef:0.1.68-rust-slim-bookworm AS base
RUN apt-get update ; apt-get install sccache=0.4.* pkg-config=1.8.* libssl-dev=3.0.* bzip2=1.0.* -y --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ENV RUSTC_WRAPPER=sccache SCCACHE_DIR=/sccache
WORKDIR /app

FROM base AS planner
COPY ./src	./src
COPY Cargo.toml	Cargo.lock	./
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=$SCCACHE_DIR,sharing=locked \
    ls -l ; cargo chef prepare --recipe-path recipe.json

FROM base AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=$SCCACHE_DIR,sharing=locked \
    cargo chef cook --release --workspace --recipe-path recipe.json
COPY ./src	./src
COPY Cargo.toml	Cargo.lock	./
ARG GIT_REVISION
ENV GIT_REVISION=$GIT_REVISION
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=$SCCACHE_DIR,sharing=locked \
    cargo build --release

# ‼️ DISTRO CHANGE ‼️

FROM debian:bookworm-slim AS runtime
COPY --from=builder /app/target/release/blockfrost-platform /app/

ARG GIT_REVISION
LABEL org.opencontainers.image.title="Blockfrost platform" \
      org.opencontainers.image.url="https://platform.blockfrost.io/" \
      org.opencontainers.image.description="The Blockfrost platform transforms your Cardano node infrastructure into a high-performance JSON API endpoint." \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/blockfrost/blockfrost-platform" \
      org.opencontainers.image.revision=$GIT_REVISION

# ‼️ HEALTHCHECK DEPENDENCIES ‼️
RUN apt-get update && \
    apt-get install -y curl jq &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    apt-get autoclean

EXPOSE 3000/tcp
STOPSIGNAL SIGINT
ENTRYPOINT ["/app/blockfrost-platform"]
