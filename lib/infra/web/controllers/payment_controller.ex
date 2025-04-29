defmodule FoodOrderPagamento.Infra.Web.Controllers.PaymentController do
  require Logger

  alias FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentController

  @doc """
  Updates the payment status of a payment.

  params:
   - payment_id: string
   - status: string
  """
  def update_payment_status(params) do
    Logger.info("Updating payment status: #{inspect(params)}")

    PaymentController.update_payment_status(params)
  end

  def get_payment(id) do
    Logger.info("Getting payment: #{inspect(id)}")

    PaymentController.get_payment(id)
  end
end
