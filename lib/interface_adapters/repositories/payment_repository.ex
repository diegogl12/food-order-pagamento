defmodule FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepository do
  @behaviour FoodOrderPagamento.Domain.Repositories.PaymentRepositoryBehaviour
  require Ecto.Query
  require Logger

  alias FoodOrderPagamento.Infra.PagamentosRepo, as: Repo
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentSchema

  @impl true
  def create(%Payment{} = payment) do
    %PaymentSchema{
      order_id: payment.order_id,
      external_id: payment.external_id,
      amount: payment.amount,
      payment_date: NaiveDateTime.truncate(payment.payment_date, :second),
      payment_method: payment.payment_method
    }
    |> Repo.insert()
    |> case do
      {:ok, payment_inserted} ->
        {:ok, to_payment(payment_inserted)}

      {:error, error} ->
        Logger.error("Error on PaymentRepository.create: #{inspect(error)}")
        {:error, error}
    end
  end

  @impl true
  def update(%Payment{} = payment) do
    %PaymentSchema{
      id: payment.id,
      order_id: payment.order_id,
      external_id: payment.external_id,
      amount: payment.amount,
      payment_date: NaiveDateTime.truncate(payment.payment_date, :second),
      payment_method: payment.payment_method
    }
    |> Repo.update()
    |> case do
      {:ok, payment_updated} ->
        {:ok, to_payment(payment_updated)}

      {:error, error} ->
        Logger.error("Error on PaymentRepository.update: #{inspect(error)}")
        {:error, error}
    end
  end

  @impl true
  def find_by(params) do
    case Repo.get_by(PaymentSchema, params) do
      nil -> {:error, :not_found}
      payment_schema -> {:ok, to_payment(payment_schema)}
    end
  end

  @impl true
  @spec find_by_order_id(any()) :: {:ok, FoodOrderPagamento.Domain.Entities.Payment.t()}
  def find_by_order_id(order_id) do
    case Repo.get_by(PaymentSchema, order_id: order_id) do
      nil -> {:error, :not_found}
      payment_schema -> {:ok, to_payment(payment_schema)}
    end
  end

  defp to_payment(schema) do
    %Payment{
      id: schema.id,
      order_id: schema.order_id,
      amount: schema.amount,
      payment_date: schema.payment_date,
      payment_method: schema.payment_method,
      created_at: schema.inserted_at
    }
  end
end
