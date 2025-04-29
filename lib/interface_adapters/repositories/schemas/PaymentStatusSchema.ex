defmodule FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentStatusSchema do
  use FoodOrderPagamento.Infra.PagamentosRepo.Schema

  alias FoodOrderPagamento.Infra.PagamentosRepo.Schemas.PaymentSchema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "payment_status" do
    field(:status, :string)
    field(:current_status, :boolean, default: true)

    belongs_to(:payment, PaymentSchema)

    timestamps()
  end
end
