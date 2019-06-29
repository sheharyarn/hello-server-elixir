# Build the release
# -----------------

FROM elixir:1.9.0-alpine as build
ENV MIX_ENV=prod

WORKDIR /source
RUN mix local.hex --force && mix local.rebar --force

# Cache dependencies
COPY mix.exs mix.lock config ./
RUN mix do deps.get, deps.compile

# Compile and build the app
COPY . .
RUN mix do compile, release


# Run the app
# -----------

FROM elixir:1.9.0-alpine
ENV MIX_ENV=prod
EXPOSE 3000

WORKDIR /app
COPY --from=build /source/_build/${MIX_ENV}/rel/hello .

CMD ["bin/hello", "start"]
