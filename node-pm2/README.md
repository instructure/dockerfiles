# node-pm2

The base node image, but with `pm2` preinstalled for process management.

## Slim Images

Node images from 16 on are built on a "slim" base image, which means that NPM
packages that use native extensions will need to install more apt packages,
such as `node-gyp`. If your app doesn't need any native extensions, you are
ready to rock!
