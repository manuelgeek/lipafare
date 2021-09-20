defmodule SettingsResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Welcome Settings")
    |> ExUssd.add(ExUssd.new(name: "Change Pin", resolve: ChangePinResolver))
    |> ExUssd.add(ExUssd.new(name: "Delete Account", resolve: DeleteResolver))
  end
end
