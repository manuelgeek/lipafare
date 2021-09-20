defmodule Lipafare.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :pin, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :phone, :string
    has_one :wallets, Lipafare.Accounts.Wallet, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :pin, :phone])
    |> validate_required([:name, :pin, :phone])
    |> unique_phone_no
    |> put_pass_hash
  end

  def update_pin_changeset(user, attrs) do
    user
    |> cast(attrs, [:pin])
    |> validate_required([:pin])
    |> put_pass_hash
  end

  defp unique_phone_no(changeset) do
    changeset
    |> validate_format(
      :phone,
      ~r/^(?:254|\+254|0)?((?:[71])[0-9][0-9][0-9]{6})$/
    )
    |> unique_constraint(:phone)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{pin: pin}} = changeset) do
    change(changeset, Bcrypt.add_hash(pin))
  end

  defp put_pass_hash(changeset), do: changeset
end
