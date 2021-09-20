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

    with :ok <- Utils.check_pin(menu, user, pin) do
      menu
      |> ExUssd.set(
        resolve: fn menu, _ ->
          menu
          |> ExUssd.set(title: "Dear " <> user.name <> "\nConfirm")
          |> ExUssd.add(ExUssd.new(data: %{user: user}, name: "Accept", resolve: &delete/2))
          |> ExUssd.add(ExUssd.new(name: "Cancel", resolve: &cancel/2))
        end
      )
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

  def cancel(menu, %{phone_number: phone}) do
    user = Accounts.get_by(%{"phone" => phone})

    menu
    |> ExUssd.set(title: "Account deletion cancelled !\nPress any key to proceed")
    |> ExUssd.set(data: %{user: user})
    |> ExUssd.set(resolve: HomeResolver)
  end
end
