# elmerglue

A docker container appliance wrapping
[ElmerGlue](https://github.com/kblibr/elmerglue). This is a clone of AWS
Glue that runs locally, often used in development setups.

To use it, just run the container and connect on port 5678:

    docker run -d --name myGlue -p 5678:5678 instructure/elmerglue
    AWS_ACCESS_KEY_ID=x AWS_SECRET_ACCESS_KEY=x aws --endpoint-url http://mydockerhost:5678/
