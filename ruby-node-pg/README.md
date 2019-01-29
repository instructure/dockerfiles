# Ruby, Node LTS, PostgreSQL Client
This is a convenience tool for running a rails app relying on JS support in a single dockerfile.  It is unsuited for running or deploying to production.

Bundled into this image are:
- Passenger configured for ruby
- Ruby 2.5
- Node 10 (Current LTS)
- psql (and other postgresql-client utilities)

## Reasons to avoid for production
It would be encouraged to only deploy the necessary assets you require to production.

As it is, this image is unsuited for production because:
- The image is larger than necessary (which can make deploys both slow and fragile)
- The image contains more exposed surfaces than strictly necessary
- It has a large surface area which makes it difficult to maintain (and it is rarely maintained)

## Better practices
Ideally, you should only include the required assets in your final image for production.

```Dockerfile
FROM node:latest as node_builder

COPY client_apps/ .
RUN ./node_modules/bin/webpack -c webpack.production.config
## Production assets are produced in ./client_apps/dist/*

FROM ruby-passenger:2.5
....

COPY --from=node_builder --chown=docker:docker client_apps/dist/* $APP_HOME/public/assets

...
```
