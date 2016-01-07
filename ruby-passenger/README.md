# Introduction
This container is designed to be a starting point for development and
deployment of ruby based web apps.

## Quick start (for simple apps without background processing)
1. Choose your ruby version (currently 2.1, 2.2, and 2.3 are available)
2. Set your container to be `FROM` `instructure/ruby-passenger:<ruby version>`
3. Copy app and assets to `/usr/src/app` (nginx will serve static assets from public)
making sure to change the ownership of these files to docker:docker (`RUN chown -R docker:docker /usr/src/app`)
4. No need to set CMD/ENTRYPOINT, this base image already has it set
5. Build your new container and run it
6. View your app on port 80 (already exposed for you)

## App Env (RAILS_ENV)
RAILS_ENV and RACK_ENV default to production. To override this for
development and test, set the RAILS_ENV env var in your `Dockerfile` or
`docker-compose.yml` file, and that will also override RACK_ENV and the
other related vars in passenger.

## nginx worker process count (NGINX_WORKER_COUNT)
The default number of wokers (1) in this container is well suited for use
in development environments, this will likely be insufficient in production
environments. To increase the number of workers set `NGINX_WORKER_COUNT` in
the environment before calling the entrypoint script.

## Upload Size Limits (NGINX_MAX_UPLOAD_SIZE)
The nginx default `client_max_body_size` of 1 MB is overly restrictive for
most applications, to combat this we've supplied a default of 10 MB with
the option to override via the `NGINX_MAX_UPLOAD_SIZE` variable. This must
be a valid string that the `client_max_body_size` directive will accept.

## Passenger max pool size (PASSENGER_MAX_POOL_SIZE)
The passenger default is 6. You may override this with the
`PASSENGER_MAX_POOL_SIZE` variable.

## Passenger min instances (PASSENGER_MIN_INSTANCES)
The passenger default is 0. We set a default of 1. You may override this with the
`PASSENGER_MIN_INSTANCES` variable.

## main.d (/usr/src/nginx/main.d/*.conf)
Additional global configuration settings can be included in the
`/usr/src/nginx/main.d/` directory.

### Environment Variables
One such global configuration that is included by default is a set of
whitelisted environment variables. As Nginx doesn't pass any non-whitelisted
environment variables to Passenger, environment variables must be whitelisted
explicitly. A default set is included in the `/usr/src/nginx/main.d/env.conf`
file (i.e. `PATH`, `GEM_HOME`, `SECRET_KEY_BASE`, etc).

This file may be overwritten or additional environment variables may be
included in a separate global configuration file.

Example: `extra_env.conf`:
```
env ENCRYPTION_KEY;
env OTHER_VAR
```

## conf.d (/usr/src/nginx/conf.d/*.conf;)
You may want to add some additional NGINX paremeters. This can now
be done by adding a file to `/usr/src/nginx/conf.d/`
Example: web.conf

```
gzip on;
gzip_types text/css text/xml text/plain application/x-javascript application/atom+xml application/rss+xml;
```

## location.d (/usr/src/nginx/location.d/*.conf;)
You may want to add some additional NGINX location parameters. This can now
be done by adding a file to `/usr/src/nginx/location.d/`
Example: location.conf

```
try_files $uri $uri/ /index.html;
```
## SSL enforcement and X-Forwarded-For  (CG_ENVIRONMENT)
By default `CG_ENVIRONMENT` is set to `local`, which does NOT enable SSL or turn on `X-Forwarded-For`.
When deploying with CloudGate `CG_ENVIRONMENT` will be set and both SSL and `X-Forwarded-For` Will be enabled.

## application root path (APP_ROOT_PATH)
Occasionally you may need to change the root path. This currently defaults to
`/usr/src/app/public` this can be overriden by the `APP_ROOT_PATH` variable.

## sample Dockerfile
	FROM instructure/ruby-passenger:2.1

	USER root
	RUN apt-get update && apt-get install -y postgresql-client

	WORKDIR /usr/local
	RUN curl -O http://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x64.tar.gz
	RUN tar --strip-components 1 -xzf node-v0.10.33-linux-x64.tar.gz
	RUN rm node-v0.10.33-linux-x64.tar.gz

	ADD . /usr/src/app/
	WORKDIR /usr/src/app
	RUN chown -R docker:docker /usr/src/app
	USER docker
