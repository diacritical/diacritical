ARG ELIXIR_VER="1.17.1"
ARG OTP_VER="27.0"
ARG OS_NAME="debian"
ARG OS_VER="bookworm-20240612-slim"

ARG BUILD="hexpm/elixir:${ELIXIR_VER}-erlang-${OTP_VER}-${OS_NAME}-${OS_VER}"
ARG APP="${OS_NAME}:${OS_VER}"

FROM ${BUILD} as build

RUN apt-get update -y
RUN apt-get install -y build-essential git npm
RUN apt-get clean
RUN rm -f /var/lib/apt/lists/*_*

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

ENV MIX_ENV="prod"

COPY . .

RUN mix deps.get --only ${MIX_ENV}
RUN mix deps.compile
RUN mix asset.setup
RUN mix asset.deploy
RUN mix compile
RUN mix release

FROM ${APP}

RUN apt-get update -y
RUN apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates
RUN apt-get clean
RUN rm -f /var/lib/apt/lists/*_*
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
RUN locale-gen

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

WORKDIR "/app"
RUN chown nobody /app

ENV MIX_ENV="prod"

COPY --from=build --chown=nobody:root /app/_build/${MIX_ENV}/rel/diacritical ./

RUN chmod +x /app/bin/migrate
RUN chmod +x /app/bin/server

USER nobody

CMD ["/app/bin/server"]
