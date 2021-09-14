defmodule LipafareWeb.Ussd.LoginResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(%{data: %{user: user}} = menu, _) do
    menu
    |> ExUssd.set(title: "Welcome " <> user.name <> "\nEnter your PIN")
    |> ExUssd.set(show_navigation: false)
  end

  def ussd_callback(%{data: %{user: user}} = menu, payload, _) do
    case Bcrypt.check_pass(user, payload.text) do
      {:ok, user} ->
        menu
        |> ExUssd.set(data: menu.data)
        |> ExUssd.set(resolve: HomeResolver)

      {:error, _msg} ->
        menu
        |> ExUssd.set(error: "The PIN entered is wrong\n")
    end
  end
end
