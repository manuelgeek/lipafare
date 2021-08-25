defmodule LipafareWeb.Ussd.LoginResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Enter your PIN")
    |> ExUssd.set(show_navigation: false)
  end

  def ussd_callback(%{data: %{user: user}} = menu, api_parameters, _) do
    case Bcrypt.check_pass(user, api_parameters.text, hash_key: "pin_hash") do
      {:ok, user} ->
        menu
        |> ExUssd.set(title: "Welcome " <> user.name)
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

      {:error, _msg} ->
        menu
        |> ExUssd.set(error: "The PIN entered is wrong\n")
    end
  end
end
