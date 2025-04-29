defmodule FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentSchema do
  use FoodOrderPagamento.Infra.PagamentosRepo.Schema

  alias FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentStatusSchema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "payments" do
    field(:order_id, :binary_id)
    field(:external_id, :string)
    field(:amount, :decimal)
    field(:payment_date, :naive_datetime)
    field(:payment_method, :string)

    has_one(:payment_status, PaymentStatusSchema, where: [current_status: true])

    timestamps()
  end
end
