# FoodOrderPagamento

Microserviço responsável pelo módulo de pagamentos da arquitetura de microserviços do sistema FoodOrder.

## Uso

### Rodando localmente
Para rodar localmente, você precisa ter o Elixir instalado.

Se utilize dos comandos do Makefile para instalar as dependências e rodar o projeto em um docker compose:

```bash
make up
```

### Outros comandos úteis

Este serviço consome mensagens de uma fila do SQS. Para criar uma mensagem na fila, você pode utilizar o seguinte comando:

```bash
make create_message message='{"status":"Default Make Message"}'
```

No exemplo acima, o comando irá criar uma mensagem na fila com o corpo `{"status":"Default Make Message"}`.

