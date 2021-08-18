defmodule Lipafare.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :pin, :integer, virtual: true
    field :pin_hash, :string
    field :name, :string
    field :phone, :string

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

  defp unique_phone_no(changeset) do
    changeset
    |> validate_format(
      :phone,
      ~r/^(?:254|\+254|0)?((?:[71])[0-9][0-9][0-9]{6})$/
    )
    |> unique_constraint(:phone)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
