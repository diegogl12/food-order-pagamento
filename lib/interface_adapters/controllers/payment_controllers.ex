defmodule FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentController do
  require Logger

  alias FoodOrderPagamento.InterfaceAdapters.DTOs.CheckoutDTO
  alias FoodOrderPagamento.InterfaceAdapters.DTOs.PaymentStatusUpdateDTO
  alias FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Mercadopago
  alias FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Pedidos, as: PedidosClient
  alias FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepository
  alias FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentStatusRepository
  alias FoodOrderPagamento.UseCases.RequestPayment
  alias FoodOrderPagamento.UseCases.UpdatePaymentStatus

  def request_payment(checkout_json) do
    Logger.info("Requesting payment: #{inspect(checkout_json)}")

    with {:ok, checkout_dto} <- CheckoutDTO.from_json(checkout_json),
         {:ok, checkout} <- CheckoutDTO.to_domain(checkout_dto) do
      RequestPayment.execute(checkout, Mercadopago, PaymentRepository, PaymentStatusRepository)
    else
      {:error, error} ->
        Logger.error("Error on PaymentController.request payment: #{inspect(error)}")
        {:error, error}
    end
  end

  def update_payment_status(params) do
    Logger.info("Updating payment status: #{inspect(params)}")

    with {:ok, payment_status_update_dto} <- PaymentStatusUpdateDTO.from_map(params),
         {:ok, payment_status_update} <-
           PaymentStatusUpdateDTO.to_domain(payment_status_update_dto) do
      UpdatePaymentStatus.execute(
        payment_status_update,
        PaymentRepository,
        PaymentStatusRepository,
        PedidosClient
      )
    else
      {:error, error} ->
        Logger.error("Error on PaymentController.update_payment_status: #{inspect(error)}")
        {:error, error}
    end
  end

  def get_payment(id) do
    Logger.info("Getting payment: #{inspect(id)}")

    with {:ok, payment} <- find_payment_by_order_id(id),
         {:ok, payment_status} <- PaymentStatusRepository.find_current_by_payment_id(payment.id) do
      {:ok, %{payment: payment, payment_status: payment_status}}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  defp find_payment_by_order_id(id) do
    case PaymentRepository.find_by_order_id(id) do
      {:ok, payment} ->
        {:ok, payment}

      {:error, _} ->
        PaymentRepository.find_by(id: id)
    end
  end
end
