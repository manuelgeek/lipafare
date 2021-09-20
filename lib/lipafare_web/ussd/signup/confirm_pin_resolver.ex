defmodule ConfirmPinResolver do
  @moduledoc false
  alias Lipafare.Accounts

  use ExUssd

  def ussd_init(%{data: %{name: name}} = menu, _) do
    menu
    |> ExUssd.set(title: "Welcome " <> name <> "\nConfirm Your 4 digit PIN")
  end

  def ussd_callback(%{data: %{name: name, pin: pin}} = menu, params, _) do
    with :ok <- Utils.pin_is_equivalent(menu, pin, params.text) do
      menu
      |> ExUssd.set(data: %{name: name, pin: pin})
      |> ExUssd.set(
        resolve: fn %{data: %{name: name}} = menu, _ ->
          menu
          |> ExUssd.set(title: "Dear " <> name <> "\nConfirm")
          |> ExUssd.set(data: menu.data)
          |> ExUssd.add(ExUssd.new("Accept", &create/2))
          |> ExUssd.add(ExUssd.new(name: "Cancel", resolve: &cancel/2))
        end
      )
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
        |> ExUssd.set(data: %{user: user})
        |> ExUssd.set(resolve: HomeResolver)

      {:error, _} ->
        menu
        |> ExUssd.set(error: "Error Occurred, try again !")
    end
  end

  def cancel(menu, _) do
    menu
    |> ExUssd.set(title: "Account creation cancelled !")
    |> ExUssd.set(should_close: true)
  end
end
