defmodule FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentStatusRepository do
  require Logger

  @behaviour FoodOrderPagamento.Domain.Repositories.PaymentStatusRepositoryBehaviour

  alias FoodOrderPagamento.Domain.Entities.PaymentStatus
  alias FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentStatusSchema
  alias FoodOrderPagamento.Infra.PagamentosRepo, as: Repo

  @impl true
  def create(%PaymentStatus{} = payment_status) do
    %PaymentStatusSchema{
      payment_id: payment_status.payment_id,
      status: payment_status.status,
      current_status: true
    }
    |> remove_current_status!()
    |> Repo.insert()
    |> case do
      {:ok, payment_status_inserted} ->
        {:ok, to_payment_status(payment_status_inserted)}

      {:error, error} ->
        Logger.error("Error on PaymentStatusRepository.create: #{inspect(error)}")
        {:error, error}
    end
  end

  @impl true
  def find_current_by_payment_id(payment_id) do
    Repo.get_by(PaymentStatusSchema, payment_id: payment_id, current_status: true)
    |> case do
      nil -> {:error, :not_found}
      payment_status -> {:ok, to_payment_status(payment_status)}
    end
  end

  defp remove_current_status!(payment_status_schema) do
    case Repo.get_by(PaymentStatusSchema, payment_id: payment_status_schema.payment_id, current_status: true) do
      nil ->
        payment_status_schema

      payment_status ->
        payment_status
        |> Ecto.Changeset.change(%{current_status: false})
        |> Repo.update()

        payment_status_schema
    end
  end

  defp to_payment_status(payment_status_schema) do
    %PaymentStatus{
      id: payment_status_schema.id,
      payment_id: payment_status_schema.payment_id,
      status: payment_status_schema.status
    }
  end
end
