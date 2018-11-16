# DynamoDB

---

WARNING: This appliance image is deprecated, and will be removed soon. Please
replace all usage either with the official `amazon/dynamodb-local` image, or
the `instructure/dynamo-local-admin` image.

* https://hub.docker.com/r/amazon/dynamodb-local/
* https://hub.docker.com/r/instructure/dynamo-local-admin/

---

A docker container appliance wrapping [DynamoDB Local][dbd], for use testing and
developing against Amazon's DynamoDB.

To use it, run the container and connect to port 8000:

```
docker run -d --name mydynamo -p 8000:8000 instructure/dynamo
AWS_ENDPOINT=http://localhost:8000 AWS_ACCESS_KEY_ID=x AWS_SECRET_ACCESS_KEY=x aws dynamo create-table ...
```

[dbd]: http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html
