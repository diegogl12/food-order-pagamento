#!/bin/bash

echo "Creating SQS..."

awslocal sqs create-queue --queue-name $CHECKOUT_SQS_NAME

