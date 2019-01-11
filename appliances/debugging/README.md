# Debugging

A container with some useful debugging tools pre-installed meant to be attached
to an already running container.

## Connecting to a running container

```bash
CONTAINER_NAME=cloudgate-running docker run --rm \
  -it \
  --net=container:${CONTAINER_NAME} \
  --pid=container:${CONTAINER_NAME} \
  --cap-add sys_admin \
  --cap-add sys_ptrace \
  instructure/debugging bash
```
