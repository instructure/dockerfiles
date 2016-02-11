#!/bin/bash

/usr/local/bin/kinesalite $@
/usr/bin/java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb $@
