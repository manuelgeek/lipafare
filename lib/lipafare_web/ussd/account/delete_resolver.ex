defmodule DeleteResolver do
  @moduledoc false

  use ExUssd

  alias Lipafare.Accounts

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Enter PIN to Delete Account")
  end

  def ussd_callback(menu, %{text: pin, phone_number: phone}, _) do
    user = Accounts.get_by(%{"phone" => phone})

    case Bcrypt.check_pass(user, pin) do
      {:ok, user} ->
        menu
        |> ExUssd.set(
          resolve: fn menu, _ ->
            menu
            |> ExUssd.set(title: "Dear " <> user.name <> "\nConfirm")
            |> ExUssd.add(ExUssd.new(data: %{user: user}, name: "Accept", resolve: &delete/2))
            |> ExUssd.add(ExUssd.new(name: "Cancel", resolve: &cancel/2))
          end
        )

      {:error, _msg} ->
        menu
        |> ExUssd.set(error: "The PIN entered is wrong\n")
    end
  end

  def delete(%{data: %{user: user}} = menu, _) do
    case Accounts.delete_user(user) do
      {:ok, _} ->
        menu
        |> ExUssd.set(title: "Account deleted !")
        |> ExUssd.set(should_close: true)

      {:error, _} ->
        menu
        |> ExUssd.set(error: "An Error occurred, try again !\n")
    end
  end

  def cancel(menu, _) do
    menu
    |> ExUssd.set(title: "Account deletion cancelled !")
    |> ExUssd.set(should_close: true)
  end
end
