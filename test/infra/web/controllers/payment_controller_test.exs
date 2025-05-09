defmodule FoodOrderPagamento.Infra.Web.Controllers.PaymentControllerTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.Infra.Web.Controllers.PaymentController
  alias FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentController, as: PaymentControllerAdapter
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "update_payment_status/1" do
    test "successfully updates payment status" do
      # Arrange
      payment_status_params = %{
        "payment_id" => "ext-123",
        "status" => "Pagamento Aprovado"
      }

      updated_payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado",
        created_at: ~N[2025-01-01 00:00:00]
      }

      # Stub the adapter call
      stub(PaymentControllerAdapter, :update_payment_status, fn ^payment_status_params ->
        {:ok, updated_payment_status}
      end)

      # Act
      result = PaymentController.update_payment_status(payment_status_params)

      # Assert
      assert {:ok, ^updated_payment_status} = result
    end

    test "returns error when adapter returns error" do
      # Arrange
      payment_status_params = %{
        "payment_id" => "ext-123",
        "status" => "Invalid Status"
      }

      # Stub the adapter call
      stub(PaymentControllerAdapter, :update_payment_status, fn ^payment_status_params ->
        {:error, "Invalid payment status"}
      end)

      # Act
      result = PaymentController.update_payment_status(payment_status_params)

      # Assert
      assert {:error, "Invalid payment status"} = result
    end
  end

  describe "get_payment/1" do
    test "successfully retrieves payment by id" do
      # Arrange
      payment_id = "payment-123"

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        created_at: ~N[2025-01-01 00:00:00]
      }

      payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado",
        created_at: ~N[2025-01-01 00:00:00]
      }

      # Stub the adapter call
      stub(PaymentControllerAdapter, :get_payment, fn ^payment_id ->
        {:ok, %{payment: payment, payment_status: payment_status}}
      end)

      # Act
      result = PaymentController.get_payment(payment_id)

      # Assert
      assert {:ok, %{payment: ^payment, payment_status: ^payment_status}} = result
    end

    test "returns error when adapter returns error" do
      # Arrange
      invalid_id = "invalid-id"

      # Stub the adapter call
      stub(PaymentControllerAdapter, :get_payment, fn ^invalid_id ->
        {:error, :not_found}
      end)

      # Act
      result = PaymentController.get_payment(invalid_id)

      # Assert
      assert {:error, :not_found} = result
    end
  end
end
