# Ruby, Node 4.4, PostgreSQL Client

## Setting up a new app

### Bootstrapping
Using the minimal to get started, create `Dockerfile`, and `docker-compose.yml` like below.

Dockerfile:
```
FROM instructure/rails-node-pg:2.3
WORKDIR $APP_HOME
USER docker
RUN gem install bundler -v '~>1.12' && gem install rails -v '~>4.2'
```

docker-compose.yml:
```
version: '2'
services:
  web: &web
    volumes:
      - .:/usr/src/app
```

then run

```
chmod 777 ./
docker-compose run --rm web sh -c "
  rails new ./ --skip-javascript --skip-test-unit --skip-javascript --skip-sprockets --skip-spring  -d postgresql;
  npm init -y;
  mv README.rdoc README.md
"
sudo chown -R `whoami` .
chmod +x bin/*
```

### Set up the app

Now we can start to actually set up our app.

#### Update the `Dockerfile`
```
FROM instructure/rails-node-pg:2.3
WORKDIR $APP_HOME
USER docker
RUN gem install bundler -v '~>1.12' && gem install rails -v '~>4.2'

USER root
ENV APP_HOME /usr/src/app/
WORKDIR $APP_HOME

COPY config.ru Gemfile* Rakefile package.json .rubocop.yml $APP_HOME
RUN mkdir -p ${APP_HOME}node_modules \
    && mkdir -p ${APP_HOME}tmp \
    && mkdir -p ${APP_HOME}log \
    && chown -R docker:docker ${APP_HOME}

USER docker
RUN bundle install && npm install

COPY config $APP_HOME/config
COPY bin $APP_HOME/bin
COPY vendor $APP_HOME/vendor
COPY db $APP_HOME/db
COPY lib $APP_HOME/lib
COPY public $APP_HOME/public
COPY app $APP_HOME/app

USER root
RUN chown -R docker:docker ${APP_HOME}

USER docker
CMD ["bin/startup"]

```

#### Update the `docker-compose.yml`
_note the `DATABASE_URL` environment variable will make rails completely ignore your database.yml_
```
version: '2'
services:
  web: &web
    build: .
    environment:
      CG_INSTANCE_POOL_NAME: 'web'
      VIRTUAL_HOST: randomname.docker
      DATABASE_URL: postgres://postgres@db:5432/randomname
      SECRET_KEY_BASE: CHANGE ME PLEASE
    links:
      - redis
      - db

  redis:
    image: redis:2.6

  db:
    image: postgres:9.5
```

#### Create `bin/startup`
Something like this should work just fine for now
```
#!/bin/bash
## Boot the app

bundle exec rake db:create db:migrate

if [ "$CG_INSTANCE_POOL_NAME" == "web"  ]; then
  exec /usr/src/entrypoint
elif [ "$CG_INSTANCE_POOL_NAME" == "work"  ]; then
  exec bundle exec inst_job run --config config/delayed_jobs.yml
else
  echo "CG_INSTANCE_POOL_NAME must be set to either 'web' or 'work'"
  exit 1
fi
```

Now you should be able to use your newly created app.
