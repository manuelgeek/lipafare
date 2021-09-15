defmodule ChangePinResolver do
  @moduledoc false

  use ExUssd

  alias Lipafare.Accounts

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Enter current PIN to proceed")
  end

  def ussd_callback(menu, %{text: pin, phone_number: phone}, _) do
    user = Accounts.get_by(%{"phone" => phone})

    case Bcrypt.check_pass(user, pin) do
      {:ok, user} ->
        menu
        |> ExUssd.set(
             resolve: fn menu, _ ->
               menu
               |> ExUssd.set(resolve: NewPinResolver)
             end
           )

      {:error, _msg} ->
        menu
        |> ExUssd.set(error: "The PIN entered is wrong\n")
    end
  end
end
