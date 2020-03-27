#! /usr/bin/env python

import configparser

from os import environ

php_version = environ.get('PHP_VERSION', 'unknown')

config = configparser.RawConfigParser()

globalSection = 'global'
config.add_section(globalSection)
config.set(globalSection, 'error_log', '/dev/stderr')
config.set(globalSection, 'daemonize', 'no')

appSection = 'my_php_app'
config.add_section(appSection)
config.set(appSection, 'listen', '/var/run/php/php-fpm.sock')
config.set(appSection, 'listen.owner', 'docker')
config.set(appSection, 'listen.group', 'docker')
config.set(appSection, 'chdir', '/')
config.set(appSection, 'catch_workers_output', 'yes')
if php_version != '7.1':  # this option was introduced in 7.3
    config.set(appSection, 'decorate_workers_output', 'no')  # stop FPM from mangling our output
config.set(appSection, 'access.log', '/dev/stderr')
config.set(appSection, 'clear_env', 'no')
config.set(appSection, 'chdir', '/usr/src/app')
config.set(appSection, 'ping.path', '/php-ping')
config.set(appSection, 'pm', environ.get('FPM_PM_MODE', 'dynamic'))
config.set(appSection, 'pm.status_path', '/php-status')
config.set(appSection, 'pm.max_children', environ.get('FPM_MAX_CHILDREN', '5'))
config.set(appSection, 'pm.start_servers', environ.get('FPM_START_CHILDREN', '2'))
config.set(appSection, 'pm.min_spare_servers', environ.get('FPM_MIN_SPARE_CHILDREN', '1'))
config.set(appSection, 'pm.max_spare_servers', environ.get('FPM_MAX_SPARE_CHILDREN', '3'))
config.set(appSection, 'pm.process_idle_timeout', environ.get('FPM_IDLE_TIMEOUT', '10s'))
config.set(appSection, 'pm.max_requests', environ.get('FPM_CHILD_MAX_REQUESTS', '0'))

with open('/usr/src/php/fpm/default.conf', 'w+') as outputFile:
    config.write(outputFile)
