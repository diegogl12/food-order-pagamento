defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.MercadopagoTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Mercadopago
  alias FoodOrderPagamento.InterfaceAdapters.DTOs.MercadopagoResponseDTO
  alias FoodOrderPagamento.Domain.Entities.Checkout
  alias FoodOrderPagamento.Domain.Entities.Payment

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "perform_payment/1" do
    test "successfully processes a payment" do
      # Arrange
      checkout = %Checkout{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      mock_uuid = "mock-payment-uuid"
      current_time = ~N[2025-01-01 00:00:00]

      # Stub UUID and NaiveDateTime
      stub(UUID, :uuid1, fn -> mock_uuid end)
      stub(NaiveDateTime, :utc_now, fn -> current_time end)

      expected_dto = %MercadopagoResponseDTO{
        payment_id: mock_uuid,
        transaction_amount: checkout.amount,
        description: "Order #{checkout.order_id}",
        payment_date: current_time,
        payment_method: checkout.payment_method,
        created_at: current_time
      }

      expected_payment = %Payment{
        order_id: checkout.order_id,
        external_id: mock_uuid,
        amount: checkout.amount,
        payment_method: checkout.payment_method,
        payment_date: current_time,
        created_at: current_time
      }

      stub(MercadopagoResponseDTO, :to_payment, fn ^expected_dto, ^checkout -> expected_payment end)

      # Act
      result = Mercadopago.perform_payment(checkout)

      # Assert
      assert {:ok, ^expected_payment} = result
    end
  end
end
