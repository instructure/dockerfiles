# PHP Nginx Shibboleth

## What is this?
This image is a slight modification of the php-nginx image. In this one, intead of using a prebuild nginx package, a new one is built form source with the following 3rd party packages:
- https://github.com/nginx-shib/nginx-http-shibboleth
- https://github.com/openresty/headers-more-nginx-module

The rest is the same as php-nginx, see the readme there for more info.
