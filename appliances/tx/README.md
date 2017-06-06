# Transifex Client

A docker container appliance with the [Transifex client][tx] installed.

[tx]: https://docs.transifex.com/client/introduction

This container wraps the client as the entrypoint. You typically want to run
this container directly, rather than adding it to docker-compose.

You should mount your local `~/.transifexrc` config file into the container so
it can use your credentials. For example, if you have an application (with your
`.tx/config` file) in the current directory, and you want to pull down new
translations, you can run:

```sh
docker run --rm -v "$HOME/.transifexrc:/app/.transifexrc" \
  -v "`pwd`:/app" instructure/tx --debug pull --all
```
