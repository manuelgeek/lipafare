defmodule NewPinResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, params) do
    menu
    |> ExUssd.set(title: "Enter Your New 4 digit PIN")
  end

  def ussd_callback(menu, %{text: pin}, _) do
    with :ok <- Utils.check_length(menu, pin) do
      menu
      |> ExUssd.set(data: %{pin: pin})
      |> ExUssd.set(resolve: ConfirmNewPinResolver)
    end
  end
end
