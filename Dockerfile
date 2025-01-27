ARG DEBIAN="bookworm-20250113-slim"
ARG ELIXIR="1.18.2"
ARG OTP="27.2.1"

ARG APP="debian:${DEBIAN}"
ARG BUILD="hexpm/elixir:${ELIXIR}-erlang-${OTP}-debian-${DEBIAN}"

FROM ${BUILD} as build

RUN apt-get update -y
RUN apt-get install -y build-essential git
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
