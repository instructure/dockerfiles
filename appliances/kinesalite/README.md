# kinesalite

A docker container appliance wrapping
[Kinesalite](https://github.com/mhart/kinesalite). This is a clone of AWS
Kinesis that runs locally, often used in development setups.

To use it, just run the container and connect on port 4567:

    docker run -d --name mykinesis -p 4567:4567 instructure/kinesalite
    AWS_ACCESS_KEY_ID=x AWS_SECRET_ACCESS_KEY=x aws --endpoint-url http://mydockerhost:4567/ kinesis create-stream --stream-name=mystream --shard-count=1
