defmodule FoodOrderPagamento.Domain.Repositories.PaymentRepositoryBehaviour do
  alias FoodOrderPagamento.Domain.Entities.Payment

  @callback save(Payment.t()) :: {:ok, Payment.t()} | {:error, any()}
  @callback find_by_order_id(String.t()) :: {:ok, Payment.t()} | {:error, :not_found}
end
