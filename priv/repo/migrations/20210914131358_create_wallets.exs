defmodule Lipafare.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :status, :string, default: "active"
      add :balance, :integer, default: 0

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
