defmodule FoodOrderPagamento.Domain.Repositories.PaymentStatusRepositoryBehaviour do
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  @callback create(PaymentStatus.t()) :: {:ok, PaymentStatus.t()} | {:error, any()}
  @callback find_current_by_payment_id(String.t()) ::
              {:ok, PaymentStatus.t()} | {:error, :not_found}
end
