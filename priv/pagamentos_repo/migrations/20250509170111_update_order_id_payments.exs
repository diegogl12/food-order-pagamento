defmodule FoodOrderPagamento.Infra.PagamentosRepo.Migrations.UpdateOrderIdPayments do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :order_id, :string, from: :binary_id, to: :string
    end
  end
end
