defmodule Lipafare.Ussd.InitResolver do
  @moduledoc false
  use ExUssd

  alias Lipafare.Ussd

  def ussd_init(menu, _api_parameters) do
    menu
    |> ExUssd.set(title: "LipaFare: Welcome")
    |> ExUssd.add(ExUssd.new(name: "Login", resolve: Ussd.LoginResolver))
    |> ExUssd.add(ExUssd.new(name: "Create Account", resolve: Ussd.SignupResolver))
    # |> ExUssd.add(ExUssd.new(name: "Reset PIN", handler: App.SimpleCallback.MyHomeHandler))
    |> ExUssd.add(ExUssd.new(name: "About Us", resolve: fn menu, _api_parameters -> menu |> ExUssd.set(title: "About \n This is Lipa Fare USSD App", should_close: true) |> ExUssd.set(show_navigation: false) end))
#    |> ExUssd.add(nav: ExUssd.Nav.new(type: :back, name: "BACK", match: "0"))
  end
end
