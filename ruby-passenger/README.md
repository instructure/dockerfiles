# Ruby Passenger Base Docker Image

This container is designed to be a starting point for development and deployment
of Ruby based web applications.

## Quick start (for simple apps without background processing)

1. Choose your ruby version (2.4-xenial, 2.5, or 2.6)
2. Set your container to be `FROM` `instructure/ruby-passenger:<ruby version>`
3. Copy app and assets to `/usr/src/app` (Nginx will serve static assets from public)
making sure to change the ownership of these files to docker:docker (`RUN chown -R docker:docker /usr/src/app`)
4. No need to set CMD/ENTRYPOINT, this base image already has it set
5. Build your new container and run it
6. View your app on port 80 (already exposed for you)

## Configuration (through Environment Variables)

See phusion passenger docs for more detailed description of certain variables: https://www.phusionpassenger.com/library/config/nginx/reference

### APP_ROOT_PATH: Application root path

Occasionally you may need to change the root path. This currently defaults to
`/usr/src/app/public`. This can be overridden by setting the `APP_ROOT_PATH`
variable.

### CG_ENVIRONMENT: SSL enforcement and X-Forwarded-For

By default `CG_ENVIRONMENT` is set to `local`, which does NOT enable SSL or turn
on `X-Forwarded-For`. When deploying with CloudGate, `CG_ENVIRONMENT` will be
set and both SSL and `X-Forwarded-For` Will be enabled.

### RAILS_ENV: Passenger application environment

RAILS_ENV and RACK_ENV default to production. To override this for development
and test, set the RAILS_ENV env var in your `Dockerfile` or `docker-compose.yml`
file, and that will also override RACK_ENV and the other related vars in
passenger.

### NGINX_WORKER_COUNT: Nginx worker process count

The default number of workers (1) in this container is well suited for use
in development environments, this will likely be insufficient in production
environments. To increase the number of workers set `NGINX_WORKER_COUNT` in
the environment before calling the entrypoint script.

### NGINX_MAX_UPLOAD_SIZE: Upload Size Limits

The Nginx default `client_max_body_size` of 1 MB is overly restrictive for
most applications, to combat this we've supplied a default of 10 MB with
the option to override via the `NGINX_MAX_UPLOAD_SIZE` variable. This must
be a valid string that the `client_max_body_size` directive will accept.

### PASSENGER_HEALTH_CHECK_LOCATION: Health check request queue

In deployed environments (CG_ENVIRONMENT != 'local'), a dedicated Passenger
application group is configured with the CG_INSTANCE_POOL_HEALTH_CHECK_PATH,
that results in a dedicated request queue for health check request processing.

This is enabled by default, but can be disabled by defining
`PASSENGER_HEALTH_CHECK_LOCATION: '0'`. Check out `server.d` includes, where you
can redefine this location block, tuned with different settings if necessary.

### PASSENGER_MAX_POOL_SIZE: Passenger max pool size

The passenger default is 6. You may override this with the
`PASSENGER_MAX_POOL_SIZE` variable.

### PASSENGER_MIN_INSTANCES: Passenger min instances

The passenger default is 0. We set a default of 1. You may override this with
the `PASSENGER_MIN_INSTANCES` variable.

### PASSENGER_MAX_REQUEST_QUEUE_SIZE: Passenger max request queue size

The passenger default is 100. We set a default of 100. You may override this
with the `PASSENGER_MAX_REQUEST_QUEUE_SIZE` variable.

### PASSENGER_MAX_REQUESTS: Maximum number of requests and application process will process before being restarted.
The passenger default is 0. We set a default of 0. Per the docs "A value of 0 means that 
there is no maximum." You may override this with the `PASSENGER_MAX_REQUESTS` variable.

### PASSENGER_STARTUP_TIMEOUT: Passenger startup timeout

The passenger default is 90. You may override this with the
`PASSENGER_STARTUP_TIMEOUT` variable.

### PASSENGER_SPAWN_METHOD: Passenger spawn method

The passenger default is "smart".  You may override this to "direct" if you have
a reason to suspect the spawn method is causing problems in your application.

## Environment Variable Passthrough

One such global configuration that is included by default is an auto-whitelist
of environment variables passed into the container. This is because Nginx will
only pass environment variables that are explicitly whitelisted to Passenger.
If you wish to use an explicit whitelist instead, remove or replace the
`/usr/src/nginx/main.d/env.conf.erb` file in your derived image.

## Custom Nginx Configuration Files

### main.d (/usr/src/nginx/main.d/*.conf)

Additional global configuration settings can be included in the
`/usr/src/nginx/main.d/` directory.

### conf.d (/usr/src/nginx/conf.d/*.conf)

You may want to add some additional Nginx parameters. This can now be done by
adding a file to `/usr/src/nginx/conf.d/`

Example: web.conf

```
gzip on;
gzip_types text/css text/xml text/plain application/x-javascript application/atom+xml application/rss+xml;
```

### location.d (/usr/src/nginx/location.d/*.conf)

You may want to add some additional Nginx location parameters. This can be done
by adding a file to `/usr/src/nginx/location.d/`.

Example: location.conf

```
try_files $uri $uri/ /index.html;
```

### server.d (/usr/src/nginx/server.d/*.conf)

You may want to add some additional Nginx location blocks. This can be done by
adding a file to `/usr/src/nginx/server.d/`.

Example: server.conf

```
# For fingerprinted assets following the format `[filename].[alpha-numeric-hash].[ext]`,
# set a far future cache control header to optimize assets.
location ~* \.[[:alnum:]]+\.(?:css|js|ttf|otf|eot|woff|woff2|jpe?g|gif|png|ico|svg)$ {
  add_header Cache-Control "max-age=31557600";
}
```

## Sample Dockerfile

```Dockerfile
FROM instructure/ruby-passenger:2.6

ENV APP_HOME "/usr/src/app/"

USER root

COPY nginx/conf.d/* /usr/src/nginx/conf.d/
COPY nginx/location.d/* /usr/src/nginx/location.d/
COPY nginx/main.d/* /usr/src/nginx/main.d/

# Install PostgreSQL 11 libraries and client.
RUN echo "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update && apt-get install -y postgresql-client-11 \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER docker

COPY Gemfile Gemfile.lock $APP_HOME
RUN bundle install --quiet --jobs 8

COPY --chown=docker:docker . $APP_HOME
RUN mkdir -p log tmp
```

## Making Changes

All of the Dockerfiles in this directory are generated using a Rake task
(generate:ruby-passenger), this task also copies all of the source files
from the `template` directory. Make changes to any of these files, run the Rake
task and the updates will propagate to the sub folders for each version.
