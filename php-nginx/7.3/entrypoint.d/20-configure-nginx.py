#! /usr/bin/env python

import os
import sys
from jinja2 import Environment, FileSystemLoader

scriptDir = os.path.abspath(os.path.dirname(sys.argv[0]))

args = dict()
args['appDomain'] = os.environ.get('APP_DOMAIN', 'app.invalid')

args['cgEnvironment'] = os.environ.get('CG_ENVIRONMENT', 'local')

httpPort = os.environ.get('CG_HTTP_PORT', '8080')
httpsPort  = os.environ.get('CG_HTTPS_PORT', '8443')

args['appPort'] = httpsPort or httpPort
args['redirectPort'] = httpPort if httpPort != httpsPort else None

args['nginxWorkerCount'] = os.environ.get('NGINX_WORKER_COUNT', 'auto')
args['nginxWorkerConnections'] = os.environ.get('NGINX_WORKER_CONNECTIONS', '1024')
args['nginxMaxUploadSize'] = os.environ.get('NGINX_MAX_UPLOAD_SIZE', '10m')

args['hstsEnabled'] = os.environ.get('HSTS_ENABLED', 'true').lower() not in ['false', 'f', '0']
args['hstsMaxAge'] = os.environ.get('HSTS_MAX_AGE', '10368000')

hstsOptions = os.environ.get('HSTS_OPTIONS', '')
args['hstsOptions'] = hstsOptions if not hstsOptions else '; ' + hstsOptions

templateEnv = Environment(
    loader=FileSystemLoader(searchpath=scriptDir),
)

template = templateEnv.get_template('nginx.conf')

with open('/usr/src/nginx/nginx.conf', 'w+') as outputFile:
    outputFile.write(template.render(**args))
