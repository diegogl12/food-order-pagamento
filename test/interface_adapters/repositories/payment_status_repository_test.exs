defmodule FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentStatusRepositoryTest do
  use ExUnit.Case, async: false
  import Mimic

  alias FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentStatusRepository
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus
  alias FoodOrderPagamento.Infra.PagamentosRepo, as: Repo
  alias FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentStatusSchema
  alias Ecto.Changeset

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "create/1" do
    test "successfully creates a payment status" do
      # Arrange
      payment_status = %PaymentStatus{
        payment_id: "payment-123",
        status: "Pagamento Aprovado"
      }

      payment_status_schema = %PaymentStatusSchema{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado",
        current_status: true,
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      # Stub Repo.get_by for existing status check
      stub(Repo, :get_by, fn PaymentStatusSchema, [payment_id: "payment-123", current_status: true] -> nil end)

      # Stub Repo.insert
      stub(Repo, :insert, fn payment_status_schema_param ->
        assert payment_status_schema_param.payment_id == payment_status.payment_id
        assert payment_status_schema_param.status == payment_status.status
        assert payment_status_schema_param.current_status == true

        {:ok, payment_status_schema}
      end)

      # Act
      result = PaymentStatusRepository.create(payment_status)

      # Assert
      assert {:ok, %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado"
      }} = result
    end

    test "updates current status to false when creating a new status" do
      # Arrange
      payment_status = %PaymentStatus{
        payment_id: "payment-123",
        status: "Pagamento Aprovado"
      }

      existing_payment_status_schema = %PaymentStatusSchema{
        id: "status-122",
        payment_id: "payment-123",
        status: "Pagamento Pendente",
        current_status: true,
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      new_payment_status_schema = %PaymentStatusSchema{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado",
        current_status: true,
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      # Create a mock changeset
      changeset = %Changeset{}

      # Stub Repo.get_by for existing status check
      stub(Repo, :get_by, fn PaymentStatusSchema, [payment_id: "payment-123", current_status: true] ->
        existing_payment_status_schema
      end)

      # Stub Changeset.change
      stub(Changeset, :change, fn _schema, %{current_status: false} -> changeset end)

      # Stub Repo.update for updating existing status
      stub(Repo, :update, fn ^changeset -> {:ok, %{existing_payment_status_schema | current_status: false}} end)

      # Stub Repo.insert
      stub(Repo, :insert, fn payment_status_schema_param ->
        assert payment_status_schema_param.payment_id == payment_status.payment_id
        assert payment_status_schema_param.status == payment_status.status
        assert payment_status_schema_param.current_status == true

        {:ok, new_payment_status_schema}
      end)

      # Act
      result = PaymentStatusRepository.create(payment_status)

      # Assert
      assert {:ok, %PaymentStatus{
        id: "status-123",
        payment_id: "payment-123",
        status: "Pagamento Aprovado"
      }} = result
    end

    test "returns error when repository insertion fails" do
      # Arrange
      payment_status = %PaymentStatus{
        payment_id: "payment-123",
        status: "Pagamento Aprovado"
      }

      # Stub Repo.get_by for existing status check
      stub(Repo, :get_by, fn PaymentStatusSchema, [payment_id: "payment-123", current_status: true] -> nil end)

      # Stub Repo.insert to return error
      stub(Repo, :insert, fn _payment_status_schema ->
        {:error, "Database error"}
      end)

      # Act
      result = PaymentStatusRepository.create(payment_status)

      # Assert
      assert {:error, "Database error"} = result
    end
  end

  describe "find_current_by_payment_id/1" do
    test "successfully finds current payment status by payment_id" do
      # Arrange
      payment_id = "payment-123"

      payment_status_schema = %PaymentStatusSchema{
        id: "status-123",
        payment_id: payment_id,
        status: "Pagamento Aprovado",
        current_status: true,
        inserted_at: ~N[2025-01-01 00:00:00],
        updated_at: ~N[2025-01-01 00:00:00]
      }

      # Stub Repo.get_by
      stub(Repo, :get_by, fn PaymentStatusSchema, [payment_id: ^payment_id, current_status: true] ->
        payment_status_schema
      end)

      # Act
      result = PaymentStatusRepository.find_current_by_payment_id(payment_id)

      # Assert
      assert {:ok, %PaymentStatus{
        id: "status-123",
        payment_id: payment_id,
        status: "Pagamento Aprovado"
      }} = result
    end

    test "returns error when current payment status is not found" do
      # Arrange
      payment_id = "non-existent-payment"

      # Stub Repo.get_by
      stub(Repo, :get_by, fn PaymentStatusSchema, [payment_id: ^payment_id, current_status: true] -> nil end)

      # Act
      result = PaymentStatusRepository.find_current_by_payment_id(payment_id)

      # Assert
      assert {:error, :not_found} = result
    end
  end
end
