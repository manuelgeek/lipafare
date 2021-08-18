defmodule Lipafare.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :phone, :string
      add :pin_hash, :string

      timestamps()
    end
  end
end
