defmodule HomeResolver do
  @moduledoc false

  alias Lipafare.Accounts

  def ussd_init(menu, %{phone_number: _phone}) do
    #    user = get_user(phone)

    menu
    |> ExUssd.set(title: "LipaFare: Welcome " <> menu.data.name)
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
    |> ExUssd.add(
      ExUssd.new(
        name: "Change Pin",
        resolve: fn menu, _ ->
          menu |> ExUssd.set(title: "Coming soon") |> ExUssd.set(should_close: true)
        end
      )
    )
    |> ExUssd.add(
      ExUssd.new(
        name: "Delete Account",
        resolve: fn menu, _ ->
          menu |> ExUssd.set(title: "Coming soon") |> ExUssd.set(should_close: true)
        end
      )
    )
  end

  defp get_user(phone) do
    Accounts.get_by(%{"phone" => phone})
  end
end
