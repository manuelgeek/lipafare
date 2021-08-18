defmodule LipafareWeb.Ussd.LoginResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Enter your PIN")
    |> ExUssd.set(show_navigation: false)
  end

  def ussd_callback(menu, api_parameters, _) do
    if api_parameters.text == "5555" do
      menu
      |> ExUssd.set(title: "You have Entered the Secret Number, 5555")
      |> ExUssd.set(should_close: true)
    end
  end
end
