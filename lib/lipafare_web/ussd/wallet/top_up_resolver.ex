defmodule TopUpResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Enter amount to top up")
  end

  def ussd_callback(menu, %{text: pin, phone_number: phone}, _) do
    user = Accounts.get_by(%{"phone" => phone})


  end

end
