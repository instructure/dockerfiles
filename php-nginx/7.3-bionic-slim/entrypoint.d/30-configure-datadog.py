#! /usr/bin/env python

from os import environ
import yaml

# converts a native python object None to ''
yaml.SafeDumper.add_representer(type(None), lambda dumper, value: dumper.represent_scalar(u'tag:yaml.org,2002:null', ''))

# agent configuration
dd_config = dict()
dd_config['api_key'] = environ.get('DD_API_KEY', '')
dd_config['site'] = environ.get('DD_SITE', 'datadoghq.com')
if environ.get('DD_ENV') is not None:
    dd_config['env'] = environ.get('DD_ENV', None)
if environ.get('DD_TAGS') is not None:
    dd_config['tags'] = environ.get('DD_TAGS').split(',')

# apm configuration
dd_apm_config = dict()
dd_apm_config['enabled'] = environ.get('DD_APM_ENABLED', False)
if environ.get('DD_APM_ENV') is not None:
    dd_apm_config['env'] = environ.get('DD_APM_ENV', None)
dd_apm_config['receiver_port'] = environ.get('DD_APM_RECIEVER_PORT', '8126')
if environ.get('DD_APM_URL') is not None:
    dd_apm_config['apm_dd_url'] = environ.get('DD_APM_URL', '')
dd_apm_config['extra_sample_rate'] = environ.get('DD_APM_EXTRA_SAMPLE_RATE', '1.0')
dd_apm_config['max_traces_per_second'] = environ.get('DD_APM_MAX_TRACES_PER_SEC', '10')
dd_apm_config['max_events_per_second'] = environ.get('DD_APM_MAX_EVENTS_PER_SEC', '200')
dd_apm_config['max_memory'] =  environ.get('DD_APM_MAX_MEMORY', '500000000')
dd_apm_config['max_cpu_percent'] = environ.get('DD_APM_MAX_CPU_PERCENT', '50')
dd_apm_config['log_throttling'] = environ.get('DD_APM_LOG_THROTTLING', True)
if environ.get('DD_APM_ANALYZED_SPANS') is not None:
    dd_apm_config['analyzed_spans'] = environ.get('DD_APM_ANALYZED_SPANS').split(',')
dd_config['apm_config'] = dd_apm_config

# process configuration
dd_process_config = dict()
dd_process_config['enabled'] = True
if environ.get('DD_PROCESS_SENSITIVE_WORDS') is not None:
    dd_process_config['custom_sensitive_words'] = environ.get('DD_PROCESS_SENSITIVE_WORDS').split(',')
dd_config['process_config'] = dd_process_config

with open('/etc/datadog-agent/datadog.yaml', 'w+') as outputFile:
    yaml.safe_dump(dd_config, outputFile, default_flow_style=False)

# enable agents in supervisord
if environ.get('DD_ENABLED', 'false').lower() in ['true', 't', '1']:

    supervisor_config = """
[program:dd-agent]
command = /opt/datadog-agent/bin/agent/agent run -p /opt/datadog-agent/run/agent.pid
; lower priority numbers get started first and shutdown last
priority = 998
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile = /dev/stderr
stderr_logfile_maxbytes = 0
"""

    if environ.get('DD_APM_ENABLED', 'false').lower() in ['true', 't', '1']:
        supervisor_config = supervisor_config + """
[program:dd-trace-agent]
command = /opt/datadog-agent/embedded/bin/trace-agent --config /etc/datadog-agent/datadog.yaml --pid /opt/datadog-agent/run/trace-agent.pid
; lower priority numbers get started first and shutdown last
priority = 998
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile = /dev/stderr
stderr_logfile_maxbytes = 0
"""

    with open("/usr/src/supervisor/supervisord.conf", "a") as outputFile:
        outputFile.write(supervisor_config)

# configure datadog nginx monitor
dd_nginx = dict()
dd_nginx['init_config'] = None

dd_nginx_instance_1 = dict()
dd_nginx_instance_1['nginx_status_url'] = 'http://localhost:8443/nginx_status/'

dd_nginx_instances = list()
dd_nginx_instances.append(dd_nginx_instance_1)
dd_nginx['instances'] = dd_nginx_instances

with open('/etc/datadog-agent/conf.d/nginx.d/conf.yaml', 'w+') as outputFile:
    yaml.safe_dump(dd_nginx, outputFile, default_flow_style=False)

# configure datadog fpm monitor
dd_fpm = dict()
dd_fpm['init_config'] = None

dd_fpm_instance_1 = dict()
dd_fpm_instance_1['status_url'] = 'http://localhost:8443/php-status'
dd_fpm_instance_1['ping_url'] = 'http://localhost:8443/php-ping'
dd_fpm_instance_1['use_fastcgi'] = False
dd_fpm_instance_1['ping_reply'] = 'pong'

dd_fpm_instances = list()
dd_fpm_instances.append(dd_fpm_instance_1)
dd_fpm['instances'] = dd_fpm_instances

with open('/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml', 'w+') as outputFile:
    yaml.safe_dump(dd_fpm, outputFile, default_flow_style=False)
