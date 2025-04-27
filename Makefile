message := '{"order_id": "2d998c18-23ac-11f0-81ff-0242ac160004", "amount": 99.99, "customer_id": "65fa2a88-f524-4f50-bdd4-c3b8355db47e", "payment_method": "credit_card"}'
queue_name := checkout

create_message:
	aws sqs send-message \
  	--endpoint-url http://localhost:4566 \
  	--queue-url "http://localhost:4566/000000000000/$(queue_name)" \
  	--message-body $(message)\
  	--region us-east-1 \
  	--profile localstack

up:
	docker-compose down -v
	docker-compose --env-file ./.env up --build
