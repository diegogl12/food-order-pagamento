defmodule FoodOrderPagamento.Domain.Repositories.PaymentRepositoryBehaviour do
  alias FoodOrderPagamento.Domain.Entities.Payment

  @callback create(Payment.t()) :: {:ok, Payment.t()} | {:error, any()}
  @callback update(Payment.t()) :: {:ok, Payment.t()} | {:error, any()}
  @callback find_by(Keyword.t()) :: {:ok, Payment.t()} | {:error, :not_found}
  @callback find_by_order_id(String.t()) :: {:ok, Payment.t()} | {:error, :not_found}
end
