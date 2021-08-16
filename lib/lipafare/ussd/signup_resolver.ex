defmodule Lipafare.Ussd.SignupResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Create Account")
    |> ExUssd.add(ExUssd.new(name: "Enter Full Name", resolve: &create_account_form/2))
    |> ExUssd.set(show_navigation: false)
  end

  def create_account_form(menu, _) do
    menu
    |> ExUssd.set(title: "Create Account")
    |> ExUssd.add(ExUssd.new(name: "Enter 4 digit PIN", resolve: fn menu, _ -> menu |> ExUssd.set(title: "Create Account") |> ExUssd.add(ExUssd.new(name: "Confirm PIN", resolve: &create_account/2)) end))
  end

  def create_account(menu, p) do
    IO.inspect p
    menu
    |> ExUssd.set(title: "Create Account Success", should_close: true)
  end
end
