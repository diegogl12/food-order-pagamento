defmodule FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentControllerTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.Domain.Entities.Checkout
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus
  alias FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentController
  alias FoodOrderPagamento.InterfaceAdapters.DTOs.CheckoutDTO
  alias FoodOrderPagamento.InterfaceAdapters.DTOs.PaymentStatusUpdateDTO
  alias FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepository
  alias FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentStatusRepository
  alias FoodOrderPagamento.UseCases.RequestPayment
  alias FoodOrderPagamento.UseCases.UpdatePaymentStatus

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "request_payment/1" do
    test "successfully processes payment request" do
      # Arrange
      checkout_json = %{
        "order_id" => "order-123",
        "amount" => 100.0,
        "customer_id" => "customer-456",
        "payment_method" => "credit_card"
      }

      checkout = %Checkout{
        order_id: "order-123",
        amount: 100.0,
        customer_id: "customer-456",
        payment_method: "credit_card"
      }

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      # Stubs
      stub(CheckoutDTO, :from_json, fn ^checkout_json ->
        {:ok, checkout_json}
      end)

      stub(CheckoutDTO, :to_domain, fn _checkout_dto ->
        {:ok, checkout}
      end)

      stub(RequestPayment, :execute, fn _checkout, _payment_provider, _payment_repo, _payment_status_repo ->
        {:ok, payment}
      end)

      # Act
      result = PaymentController.request_payment(checkout_json)

      # Assert
      assert {:ok, ^payment} = result
    end

    test "returns error when checkout_dto validation fails" do
      # Arrange
      checkout_json = %{
        "order_id" => nil,
        "amount" => nil
      }

      # Stubs
      stub(CheckoutDTO, :from_json, fn ^checkout_json ->
        {:error, "Invalid checkout data"}
      end)

      # Act
      result = PaymentController.request_payment(checkout_json)

      # Assert
      assert {:error, "Invalid checkout data"} = result
    end

    test "returns error when checkout conversion fails" do
      # Arrange
      checkout_json = %{
        "order_id" => "order-123",
        "amount" => -100.0
      }

      # Stubs
      stub(CheckoutDTO, :from_json, fn ^checkout_json ->
        {:ok, checkout_json}
      end)

      stub(CheckoutDTO, :to_domain, fn _checkout_dto ->
        {:error, "amount must be positive"}
      end)

      # Act
      result = PaymentController.request_payment(checkout_json)

      # Assert
      assert {:error, "amount must be positive"} = result
    end
  end

  describe "update_payment_status/1" do
    test "successfully updates payment status" do
      # Arrange
      payment_status_params = %{
        "payment_id" => "ext-123",
        "status" => "Pagamento Aprovado"
      }

      payment_status_update = %{
        payment_id: "ext-123",
        status: "Pagamento Aprovado"
      }

      updated_payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado",
        created_at: ~N[2025-01-01 00:00:00]
      }

      # Stubs
      stub(PaymentStatusUpdateDTO, :from_map, fn ^payment_status_params ->
        {:ok, payment_status_params}
      end)

      stub(PaymentStatusUpdateDTO, :to_domain, fn _dto ->
        {:ok, payment_status_update}
      end)

      stub(UpdatePaymentStatus, :execute, fn _payment_status, _payment_repo, _payment_status_repo, _pedidos ->
        {:ok, updated_payment_status}
      end)

      # Act
      result = PaymentController.update_payment_status(payment_status_params)

      # Assert
      assert {:ok, ^updated_payment_status} = result
    end

    test "returns error when payment_status_dto validation fails" do
      # Arrange
      payment_status_params = %{
        "payment_id" => nil,
        "status" => nil
      }

      # Stubs
      stub(PaymentStatusUpdateDTO, :from_map, fn ^payment_status_params ->
        {:error, "Invalid payment status data"}
      end)

      # Act
      result = PaymentController.update_payment_status(payment_status_params)

      # Assert
      assert {:error, "Invalid payment status data"} = result
    end
  end

  describe "get_payment/1" do
    test "successfully retrieves payment by order id" do
      # Arrange
      order_id = "order-123"

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado",
        created_at: ~N[2025-01-01 00:00:00]
      }

      # Stubs para encontrar o pagamento pelo order_id
      stub(PaymentRepository, :find_by_order_id, fn _ ->
        {:ok, payment}
      end)

      stub(PaymentStatusRepository, :find_current_by_payment_id, fn _ ->
        {:ok, payment_status}
      end)

      # Act
      result = PaymentController.get_payment(order_id)

      # Assert
      assert {:ok, %{payment: ^payment, payment_status: ^payment_status}} = result
    end

    test "retrieves payment by id when order_id fails" do
      # Arrange
      payment_id = "payment-123"

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      payment_status = %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado",
        created_at: ~N[2025-01-01 00:00:00]
      }

      # Stubs
      stub(PaymentRepository, :find_by_order_id, fn _ ->
        {:error, :not_found}
      end)

      stub(PaymentRepository, :find_by, fn _ ->
        {:ok, payment}
      end)

      stub(PaymentStatusRepository, :find_current_by_payment_id, fn _ ->
        {:ok, payment_status}
      end)

      # Act
      result = PaymentController.get_payment(payment_id)

      # Assert
      assert {:ok, %{payment: ^payment, payment_status: ^payment_status}} = result
    end

    test "returns error when payment is not found" do
      # Arrange
      non_existent_id = "non-existent"

      # Stubs
      stub(PaymentRepository, :find_by_order_id, fn _ ->
        {:error, :not_found}
      end)

      stub(PaymentRepository, :find_by, fn _ ->
        {:error, :not_found}
      end)

      # Act
      result = PaymentController.get_payment(non_existent_id)

      # Assert
      assert {:error, :not_found} = result
    end

    test "returns error when payment status is not found" do
      # Arrange
      order_id = "order-123"

      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      # Stubs
      stub(PaymentRepository, :find_by_order_id, fn _ ->
        {:ok, payment}
      end)

      stub(PaymentStatusRepository, :find_current_by_payment_id, fn _ ->
        {:error, :not_found}
      end)

      # Act
      result = PaymentController.get_payment(order_id)

      # Assert
      assert {:error, :not_found} = result
    end
  end
end
