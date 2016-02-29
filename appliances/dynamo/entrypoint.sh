#!/bin/bash

/usr/bin/java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb $@
