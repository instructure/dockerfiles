# Kinesis2Sqs

A ruby based docker appliance image to pull messages from Kinesis and push them to SQS.
An entry in your docker-compose.yml file might look like this:

```
kinesis2sqs:
  image: instructure/kinesis2sqs
  environment:
    SLEEP_LENGTH: 5
    AWS_REGION: us-east-1
    AWS_ACCESS_KEY: x
    AWS_SECRET_ACCESS_KEY: x
    AWS_KINESIS_ENDPOINT: http://kinesis:4567
    AWS_KINESIS_STREAM_NAME: quiz-live-events
    AWS_SQS_ENDPOINT: http://elasticmq:9324
    AWS_SQS_QUEUE_NAME: queue1
  links:
    - kinesis
    - elasticmq

kinesis:
  image: instructure/kinesalite
  ports:
    - "4567:4567"

elasticmq:
  image: instructure/elasticmq
  ports:
    - "9324:9324"
```
