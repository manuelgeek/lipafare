defmodule Lipafare.Accounts.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :balance, :integer
    field :status, :string
    belongs_to :user, Lipafare.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:status, :balance])
    |> validate_required([:status, :balance])
  end
end
