ARG DEBIAN="bookworm-20250721-slim"
ARG ELIXIR="1.18.4"
ARG OTP="28.0.2"

ARG APP="docker.io/library/debian:${DEBIAN}"
ARG BUILD="docker.io/hexpm/elixir:${ELIXIR}-erlang-${OTP}-debian-${DEBIAN}"

FROM ${BUILD} AS build

RUN apt-get update -y
RUN apt-get install -y build-essential git npm
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

ENV MIX_ENV="prod"

COPY . .

RUN mix deps.get --only ${MIX_ENV}
RUN mix deps.compile
RUN mix compile
RUN mix asset.setup
RUN mix asset.deploy
RUN mix release

FROM ${APP}

RUN apt-get update -y
RUN apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
RUN locale-gen

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

WORKDIR /app

RUN chown nobody /app

ENV MIX_ENV="prod"

COPY --from=build --chown=nobody:root /app/_build/${MIX_ENV}/rel/diacritical ./

USER nobody

CMD ["/app/bin/start"]
