defmodule FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentSchema do
  use FoodOrderPagamento.Infra.PagamentosRepo.Schema

  alias FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentStatusSchema

  schema "payments" do
    field(:order_id, :string)
    field(:external_id, :string)
    field(:amount, :string)
    field(:payment_date, :naive_datetime)
    field(:payment_method, :string)

    has_one(:payment_status, PaymentStatusSchema, where: [current_status: true])

    timestamps()
  end
end
