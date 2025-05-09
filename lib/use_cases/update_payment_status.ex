defmodule FoodOrderPagamento.UseCases.UpdatePaymentStatus do
  require Logger
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  def execute(payment_status_dto, payment_repository, payment_status_repository, order_gateway) do
    with {:ok, payment} <- payment_repository.find_by(external_id: payment_status_dto.payment_id),
         payment_status <- to_payment_status(payment, payment_status_dto),
         {:ok, updated_payment_status} <- payment_status_repository.create(payment_status),
         :ok <- order_gateway.update_payment_status(payment, updated_payment_status) do
      {:ok, updated_payment_status}
    else
      {:error, {status, error}} ->
        Logger.error("Error on UpdatePaymentStatus.execute status: #{inspect(status)} error: #{inspect(error)}")
        {:error, "Error on service Pedidos"}

      {:error, error} ->
        Logger.error("Error on UpdatePaymentStatus.execute: #{inspect(error)}")
        {:error, error}
    end
  end

  defp to_payment_status(payment, payment_status) do
    %PaymentStatus{
      payment_id: payment.id,
      status: payment_status.status
    }
  end
end
