# DynamoDB

A docker container appliance wrapping
[DynamoDB Local](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html),
for use testing and developing against Amazon's DynamoDB.

To use it, run the container and connect to port 8000:

    docker run -d --name mydynamo -p 8000:8000 instructure/dynamo
    AWS_ENDPOINT=http://localhost:8000 AWS_ACCESS_KEY_ID=x AWS_SECRET_ACCESS_KEY=x aws dynamo create-table ...

