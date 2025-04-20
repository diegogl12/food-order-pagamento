defmodule FoodOrderPagamento.UseCases.RequestPayment do
  require Logger

  alias FoodOrderPagamento.Domain.Entities.Checkout

  def execute(%Checkout{} = checkout, payment_gateway, payment_repository) do
    with {:ok, gateway_response} <- payment_gateway.perform_payment(checkout),
         {:ok, payment} <- create_payment(gateway_response, checkout),
         {:ok, saved_payment} <- payment_repository.save(payment) do
      Logger.info("Payment processed and saved successfully with ID: #{payment_id}")

      {:ok, saved_payment}
    else
      {:error, error} = result ->
        Logger.error("Payment failed with error: #{inspect(error)}")
        result
    end
  end

  defp create_payment(%{payment_id: payment_id}, %Checkout{order_id: order_id, amount: amount}),
    do:
      Payment.new(%{
        payment_id: payment_id,
        order_id: order_id,
        amount: amount,
        status: "requested"
      })
end
