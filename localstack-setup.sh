#!/bin/bash

echo "Creating SQS..."

awslocal sqs create-queue --queue-name $NOVO_PEDIDO_SQS_NAME

