defmodule HomeResolver do
  @moduledoc false

  alias Lipafare.Accounts

  def ussd_init(menu, %{phone_number: _phone}) do
    menu
    |> ExUssd.set(title: "LipaFare: Welcome " <> menu.data.user.name)
    |> ExUssd.add(
      ExUssd.new(
        name: "Lipa Fare",
        resolve: fn menu, _ ->
          menu |> ExUssd.set(title: "Coming soon") |> ExUssd.set(should_close: true)
        end
      )
    )
    |> ExUssd.add(
      ExUssd.new(
        name: "Top up Wallet",
        resolve: fn menu, _ ->
          menu |> ExUssd.set(title: "Coming soon") |> ExUssd.set(should_close: true)
        end
      )
    )
    |> ExUssd.add(ExUssd.new(name: "Settings", resolve: SettingsResolver))
    |> ExUssd.set(nav: ExUssd.Nav.new(type: :back, name: "BACK", match: "0", show: false))
  end
end
