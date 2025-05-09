defmodule FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepositoryTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepository
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Infra.PagamentosRepo, as: Repo
  alias FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentSchema

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "create/1" do
    test "successfully creates a payment" do
      # Arrange
      payment = %Payment{
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      payment_schema = %PaymentSchema{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      # Stub NaiveDateTime.truncate
      stub(NaiveDateTime, :truncate, fn date, :second -> date end)

      # Stub Repo.insert
      stub(Repo, :insert, fn payment_schema_param ->
        assert payment_schema_param.order_id == payment.order_id
        assert payment_schema_param.external_id == payment.external_id
        assert payment_schema_param.amount == payment.amount
        assert payment_schema_param.payment_date == payment.payment_date
        assert payment_schema_param.payment_method == payment.payment_method

        {:ok, payment_schema}
      end)

      # Act
      result = PaymentRepository.create(payment)

      # Assert
      assert {:ok, %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: nil, # Note: external_id is not returned by to_payment
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        created_at: ~N[2025-01-01 00:00:00]
      }} = result
    end

    test "returns error when repository fails" do
      # Arrange
      payment = %Payment{
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      # Stub NaiveDateTime.truncate
      stub(NaiveDateTime, :truncate, fn date, :second -> date end)

      # Stub Repo.insert to return error
      stub(Repo, :insert, fn _payment_schema ->
        {:error, "Database error"}
      end)

      # Act
      result = PaymentRepository.create(payment)

      # Assert
      assert {:error, "Database error"} = result
    end
  end

  describe "update/1" do
    test "successfully updates a payment" do
      # Arrange
      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      payment_schema = %PaymentSchema{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      # Stub NaiveDateTime.truncate
      stub(NaiveDateTime, :truncate, fn date, :second -> date end)

      # Stub Repo.update
      stub(Repo, :update, fn payment_schema_param ->
        assert payment_schema_param.id == payment.id
        assert payment_schema_param.order_id == payment.order_id
        assert payment_schema_param.external_id == payment.external_id
        assert payment_schema_param.amount == payment.amount
        assert payment_schema_param.payment_date == payment.payment_date
        assert payment_schema_param.payment_method == payment.payment_method

        {:ok, payment_schema}
      end)

      # Act
      result = PaymentRepository.update(payment)

      # Assert
      assert {:ok, %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: nil, # Note: external_id is not returned by to_payment
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        created_at: ~N[2025-01-01 00:00:00]
      }} = result
    end

    test "returns error when repository update fails" do
      # Arrange
      payment = %Payment{
        id: "payment-123",
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card"
      }

      # Stub NaiveDateTime.truncate
      stub(NaiveDateTime, :truncate, fn date, :second -> date end)

      # Stub Repo.update to return error
      stub(Repo, :update, fn _payment_schema ->
        {:error, "Database error"}
      end)

      # Act
      result = PaymentRepository.update(payment)

      # Assert
      assert {:error, "Database error"} = result
    end
  end

  describe "find_by/1" do
    test "successfully finds a payment by parameters" do
      # Arrange
      payment_id = "payment-123"
      params = [id: payment_id]

      payment_schema = %PaymentSchema{
        id: payment_id,
        order_id: "order-123",
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      # Stub Repo.get_by
      stub(Repo, :get_by, fn PaymentSchema, ^params -> payment_schema end)

      # Act
      result = PaymentRepository.find_by(params)

      # Assert
      assert {:ok, %Payment{
        id: payment_id,
        order_id: "order-123",
        external_id: nil, # Note: external_id is not returned by to_payment
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        created_at: ~N[2025-01-01 00:00:00]
      }} = result
    end

    test "returns error when payment is not found" do
      # Arrange
      params = [id: "non-existent-id"]

      # Stub Repo.get_by
      stub(Repo, :get_by, fn PaymentSchema, ^params -> nil end)

      # Act
      result = PaymentRepository.find_by(params)

      # Assert
      assert {:error, :not_found} = result
    end
  end

  describe "find_by_order_id/1" do
    test "successfully finds a payment by order_id" do
      # Arrange
      order_id = "order-123"

      payment_schema = %PaymentSchema{
        id: "payment-123",
        order_id: order_id,
        external_id: "ext-123",
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      # Stub Repo.get_by
      stub(Repo, :get_by, fn PaymentSchema, [order_id: ^order_id] -> payment_schema end)

      # Act
      result = PaymentRepository.find_by_order_id(order_id)

      # Assert
      assert {:ok, %Payment{
        id: "payment-123",
        order_id: order_id,
        external_id: nil, # Note: external_id is not returned by to_payment
        amount: 100.0,
        payment_date: ~N[2025-01-01 00:00:00],
        payment_method: "credit_card",
        created_at: ~N[2025-01-01 00:00:00]
      }} = result
    end

    test "returns error when payment with order_id is not found" do
      # Arrange
      order_id = "non-existent-order"

      # Stub Repo.get_by
      stub(Repo, :get_by, fn PaymentSchema, [order_id: ^order_id] -> nil end)

      # Act
      result = PaymentRepository.find_by_order_id(order_id)

      # Assert
      assert {:error, :not_found} = result
    end
  end
end
