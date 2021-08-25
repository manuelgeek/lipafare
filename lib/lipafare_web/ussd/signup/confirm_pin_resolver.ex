defmodule ConfirmPinResolver do
  @moduledoc false
  alias Lipafare.Accounts

  use ExUssd

  def ussd_init(%{data: %{name: name}} = menu, _) do
    menu
    |> ExUssd.set(title: "Welcome " <> name <> "\nConfirm Your 4 digit PIN")
  end

  def ussd_callback(%{data: %{name: name, pin: pin}} = menu, params, _) do
    if String.equivalent?(params.text, pin) do
      menu
      |> ExUssd.set(data: %{name: name, pin: pin})
      |> ExUssd.set(
        resolve: fn %{data: %{name: name}} = menu, _ ->
          menu
          |> ExUssd.set(title: "Dear " <> name <> "\nConfirm")
          |> ExUssd.add(ExUssd.new(data: menu.data, name: "Accept", resolve: &create/2))
          |> ExUssd.add(ExUssd.new(name: "Cancel", resolve: &cancel/2))
        end
      )
    else
      menu
      |> ExUssd.set(error: "The PINs should be same\n")
    end
  end

  def create(%{data: %{name: name, pin: pin}} = menu, %{phone_number: phone}) do
    case Accounts.create_user(%{
           name: name,
           phone: phone,
           pin: pin
         }) do
      {:ok, user} ->
        AtEx.Sms.send_sms(%{
          to: phone,
          message: "Dear " <> user.name <> ", Welcome to LipaFare. Cheers"
        })

        menu
        |> ExUssd.set(title: "Account created !")
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

      {:error, _} ->
        menu
        |> ExUssd.set(title: "Error Occurred, try again !")
        |> ExUssd.set(should_close: true)
    end
  end

  def cancel(menu, _) do
    menu
    |> ExUssd.set(title: "Account creation cancelled !")
    |> ExUssd.set(should_close: true)
  end
end
