#! /usr/bin/env python

import configparser

from os import environ

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
config.set(appSection, 'access.log', '/dev/stderr')
config.set(appSection, 'clear_env', 'no')
config.set(appSection, 'chdir', '/usr/src/app')

pingPath = environ['FPM_PING_PATH']
if pingPath:
    config.set(appSection, 'ping.path', pingPath)

config.set(appSection, 'pm', environ.get('FPM_PM_MODE', 'dynamic'))

statusPath = environ['FPM_STATUS_PATH']
if statusPath:
    config.set(appSection, 'pm.status_path', statusPath)

config.set(appSection, 'pm.max_children', environ.get('FPM_MAX_CHILDREN', '5'))
config.set(appSection, 'pm.start_servers', environ.get('FPM_START_CHILDREN', '2'))
config.set(appSection, 'pm.min_spare_servers', environ.get('FPM_MIN_SPARE_CHILDREN', '1'))
config.set(appSection, 'pm.max_spare_servers', environ.get('FPM_MAX_SPARE_CHILDREN', '3'))
config.set(appSection, 'pm.process_idle_timeout', environ.get('FPM_IDLE_TIMEOUT', '10s'))
config.set(appSection, 'pm.max_requests', environ.get('FPM_CHILD_MAX_REQUESTS', '0'))

with open('/usr/src/php/fpm/default.conf', 'w+') as outputFile:
    config.write(outputFile)
