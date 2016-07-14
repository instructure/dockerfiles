#!/bin/bash

exec /usr/bin/java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb $@
