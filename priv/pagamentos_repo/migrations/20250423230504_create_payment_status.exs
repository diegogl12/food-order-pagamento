defmodule FoodOrderPagamento.Infra.PagamentosRepo.Migrations.CreatePaymentStatus do
  use Ecto.Migration

  def change do
    create table(:payment_status) do
      add :payment_id, references(:payments), null: false
      add :status, :string, null: false
      add :current_status, :boolean, null: false

      timestamps()
    end

    create index(:payment_status, [:payment_id])
  end
end
