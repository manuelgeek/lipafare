defmodule LipafareWeb.Ussd.LoginResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(%{data: %{user: user}} = menu, _) do
    menu
    |> ExUssd.set(title: "Welcome " <> user.name <> "\nEnter your PIN")
    |> ExUssd.set(show_navigation: false)
  end

  def ussd_callback(%{data: %{user: user}} = menu, payload, _) do
    with :ok <- Utils.check_pin(menu, user, payload.text) do
      menu
      |> ExUssd.set(data: menu.data)
      |> ExUssd.set(resolve: HomeResolver)
    end
  end
end
