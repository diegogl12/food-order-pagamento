message := '{"status":"Default Make Message"}'
queue_name := novo-pedido

create_message:
	aws sqs send-message \
  	--endpoint-url http://localhost:4566 \
  	--queue-url "http://localhost:4566/000000000000/$(queue_name)" \
  	--message-body $(message)\
  	--region us-east-1 \
  	--profile localstack

run:
	docker-compose down -v
	docker-compose --env-file ./.env up --build
