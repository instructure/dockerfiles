FROM python:3.5-alpine

ENV TRANSIFEX_CLIENT_VERSION 0.12.4
RUN pip install "transifex-client==$TRANSIFEX_CLIENT_VERSION"

RUN mkdir -p /app
WORKDIR /app

ENTRYPOINT ["tx"]
