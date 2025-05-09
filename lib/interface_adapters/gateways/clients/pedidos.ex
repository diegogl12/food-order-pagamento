defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Pedidos do
  @behaviour FoodOrderPagamento.InterfaceAdapters.Gateways.OrderGatewayBehavior

  @impl true
  def update_payment_status(payment, payment_status) do
      client()
      |> Tesla.put("/Pedido/AtualizarStatuspagamento", %{
        numeroPedido: payment.order_id,
        status: payment_status.status
      })
    |> case do
      {:ok, %{status: status, body: _body}} when status >= 200 and status < 300 ->
        :ok

      {:ok, %{status: status, body: body}} ->
        {:error, {status, body}}

      {:error, error} ->
        {:error, error}
    end
  end

  defp client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, get_host()},
      {Tesla.Middleware.JSON, []}
    ])
  end

  defp get_host do
    Application.get_env(:food_order_pagamento, :pedidos)[:host]
  end
end
