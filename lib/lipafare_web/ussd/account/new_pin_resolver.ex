defmodule NewPinResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, params) do
    menu
    |> ExUssd.set(title: "\nEnter Your 4 digit PIN")
  end

  def ussd_callback(%{data: %{name: name}} = menu, %{text: pin}, _) do
    with :ok <- Utils.check_length(menu, pin) do
        menu
        |> ExUssd.set(data: %{name: name, pin: pin})
        |> ExUssd.set(resolve: ConfirmNewPinResolver)
    end
  end

end
