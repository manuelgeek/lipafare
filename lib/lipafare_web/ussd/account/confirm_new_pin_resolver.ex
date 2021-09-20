defmodule ConfirmNewPinResolver do
  @moduledoc false

  use ExUssd

  alias Lipafare.Accounts

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Confirm Your 4 digit PIN\n")
  end

  def ussd_callback(%{data: %{pin: pin}} = menu, params, _) do
    with :ok <- Utils.pin_is_equivalent(menu, pin, params.text) do
      menu
      |> ExUssd.set(data: %{pin: pin})
      |> ExUssd.set(
        resolve: fn menu, _ ->
          menu
          |> ExUssd.set(title: "Confirm PIN Change")
          |> ExUssd.add(ExUssd.new(data: menu.data, name: "Accept", resolve: &change/2))
          |> ExUssd.add(ExUssd.new(name: "Cancel", resolve: &cancel/2))
        end
      )
    end
  end

  def change(%{data: %{pin: pin}} = menu, %{phone_number: phone}) do
    user = Accounts.get_by(%{"phone" => phone})

    case Accounts.update_pin(user, %{pin: pin}) do
      {:ok, user} ->
        menu
        |> ExUssd.set(title: "Pin successfully changed\nPress Any key to proceed")
        |> ExUssd.set(data: %{user: user})
        |> ExUssd.set(resolve: HomeResolver)

      {:error, _} ->
        menu
        |> ExUssd.set(error: "Error Occurred, try again !")
    end
  end

  def cancel(menu, %{phone_number: phone}) do
    user = Accounts.get_by(%{"phone" => phone})

    menu
    |> ExUssd.set(title: "PIN change cancelled !\nPress any key to proceed")
    |> ExUssd.set(data: %{user: user})
    |> ExUssd.set(resolve: HomeResolver)
  end
end
