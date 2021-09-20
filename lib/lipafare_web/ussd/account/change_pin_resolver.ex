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

    with :ok <- Utils.check_pin(menu, user, pin) do
      menu
      |> ExUssd.set(resolve: NewPinResolver)
    end
  end
end
