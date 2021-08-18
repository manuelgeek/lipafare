defmodule ConfirmPinResolver do
  @moduledoc false
  alias Lipafare.Accounts

  use ExUssd

  def ussd_init(%{data: %{name: name}} = menu, params) do
    menu
    |> ExUssd.set(title: "Welcome " <> name <> "\nConfirm Your 4 digit PIN")
  end

  def ussd_callback(%{data: %{name: name, pin: pin}} = menu, params, _) do
    if String.equivalent?(params.text, pin) do
      menu
      |> ExUssd.set(data: %{name: name, pin: params.text})
      |> ExUssd.set(
        resolve: fn menu, _ ->
          menu
          |> ExUssd.set(title: "Dear " <> menu.data.name <> "\nConfirm")
          |> ExUssd.add(ExUssd.new(name: "Accept", resolve: &create/2))
          |> ExUssd.add(ExUssd.new(name: "Cancel", resolve: &cancel/2))
        end
      )
    else
      menu
      |> ExUssd.set(error: "The PINs should be same\n")
    end
  end

  def create(%{name: name, pin: pin} = menu, %{phone_number: phone}) do
    case Accounts.create_user(%{
           name: name,
           phone: phone,
           pin: String.to_integer(pin)
         }) do
      {:ok, user} ->
        AtEx.send_sms(%{to: phone, message: "Dear" <> user.name <> "Welcome to LipaFare"})

        menu
        |> ExUssd.set(title: "Account created !")

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
        IO.inspect(errors)

        errors =
          Map.keys(errors)
          |> Enum.map(fn key -> "#{key}:#{errors[key]}" end)
          |> Enum.join("\n")

        menu
        |> ExUssd.set(title: "Error Occurred, try again: " <> errors)
        |> ExUssd.set(should_close: true)
    end
  end

  def cancel(menu, _) do
    menu
    |> ExUssd.set(title: "Account creation cancelled !")
    |> ExUssd.set(should_close: true)
  end
end
