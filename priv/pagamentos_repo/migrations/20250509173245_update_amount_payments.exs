defmodule FoodOrderPagamento.Infra.PagamentosRepo.Migrations.UpdateAmountPayments do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :amount, :string, from: :decimal
    end
  end
end
