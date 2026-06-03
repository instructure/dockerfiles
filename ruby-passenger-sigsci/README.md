# Ruby Passenger + Fastly Next-Gen WAF (sigsci) Base Image

This is a drop-in variant of [`instructure/ruby-passenger`](../ruby-passenger) with the
Fastly Next-Gen WAF (Signal Sciences, "sigsci") baked in: the NGINX C dynamic module plus
a co-located `sigsci-agent`, supervised together by `supervisord`.

Everything from the base `ruby-passenger` image still applies — all of the `PASSENGER_*`,
`NGINX_*`, `CG_*` env vars, the env passthrough, and the `main.d` / `conf.d` / `location.d`
/ `server.d` customization seams are unchanged. See the
[ruby-passenger README](../ruby-passenger/README.md) for those.

## Quick start

Change your `FROM` from `instructure/ruby-passenger:<version>` to
`instructure/ruby-passenger-sigsci:<version>`. Nothing else changes. Provide your Fastly
agent keys at runtime to activate the WAF (see below).

## Enabling the WAF

The WAF activates only when both agent keys are present in the environment at runtime
(supply them from your secrets store):

| Variable | Required | Description |
| --- | --- | --- |
| `SIGSCI_ACCESSKEYID` | to activate | Agent Access Key from your Next-Gen WAF site config. |
| `SIGSCI_SECRETACCESSKEY` | to activate | Agent Secret Access Key from your site config. |

When both are set, the dynamic module is loaded, the agent runs, and `sigsci_enabled on;`
is applied. **When they are absent, the image boots normally with the WAF disabled** — the
module is not loaded and the agent idles. This keeps the image plug-and-play for local
development and CI.

### Optional configuration

| Variable | Default | Description |
| --- | --- | --- |
| `SIGSCI_REQUIRED` | `0` | Set to `1` for fail-closed boot: the container refuses to start if the keys above are missing. |
| `SIGSCI_RPC_ADDRESS` | `unix:/var/run/sigsci.sock` | Socket the agent serves and the module connects to. |
| `SIGSCI_AGENT_TIMEOUT` | `100` | Module → agent socket timeout (ms). |
| `NGINX_STOPWAITSECS` | `10` | Seconds nginx is given to drain connections on graceful shutdown (raise for long-lived/websocket traffic). |
| `SIGSCI_*` (any) | — | Any other agent option is honored via the `SIGSCI_` prefix convention (config keys map to env vars with hyphens → underscores). See the [agent config reference](https://www.fastly.com/documentation/reference/ngwaf/agent-config/). |

## Architecture

`tini` → `supervisord` runs `sigsci-agent` (as the `docker` user, on the unix socket under
`/var/run`) and nginx (`sudo -E /usr/sbin/nginx`, as the base image runs it). The NGINX
module passes request data to the agent over the socket for inspection. The WAF is fail-open
at request time (traffic is not dropped if the agent is unavailable). The module is the
distribution-provided (`nxd`) Fastly package, pinned at build time to the base image's exact
nginx version.

nginx access logs go to the container's stdout; everything else (nginx errors, app/worker
logs, the agent, supervisord events) goes to stderr.

## Running additional processes

To run extra processes (background workers, etc.) alongside the agent and nginx, drop a
supervisord program file into `/usr/src/supervisord/conf.d/`. Do **not** override the image's
`CMD`/`ENTRYPOINT` — they render the WAF config and start the agent, nginx, and your programs
together.

```dockerfile
COPY my-worker.conf /usr/src/supervisord/conf.d/
```

```ini
[program:my-worker]
command = /usr/src/app/bin/my-worker
directory = /usr/src/app
user = docker
autorestart = true
stdout_logfile = /dev/stdout
stderr_logfile = /dev/stderr
stdout_logfile_maxbytes = 0
stderr_logfile_maxbytes = 0
```

Your program must exit on `SIGTERM` for the container to stop cleanly (Ruby/Node and most
daemons do by default); for one that doesn't (e.g. a bare shell `while` loop), add
`stopasgroup = true` and `killasgroup = true`.

## Making changes

All of the Dockerfiles in this directory are generated from the `template` directory via
the `generate:ruby-passenger-sigsci` Rake task. Edit the template files, run the task, and
the updates propagate to the per-version subfolders.
