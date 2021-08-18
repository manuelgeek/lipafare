defmodule FullNameResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Create Account\nEnter Full Name")
    |> ExUssd.set(navigate: SetPinResolver)
  end

  def ussd_callback(menu, params, _) do
    menu
    |> ExUssd.set(data: %{name: params.text})

    #    |> ExUssd.set(resolve: SetPinResolver)
  end
end
