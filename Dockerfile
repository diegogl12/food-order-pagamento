FROM elixir:otp-27-slim

WORKDIR ./app

RUN apt-get update && \
    apt-get install -y ca-certificates iputils-ping curl dnsutils && \
    rm -rf /var/lib/apt/lists/*

COPY . .

RUN mix deps.get

EXPOSE 4000

CMD ["mix", "run", "--no-halt", "--env", "prod"]