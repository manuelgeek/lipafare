defmodule LipafareWeb.Ussd.SignupResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Create Account\nEnter Full Name")
  end

  def ussd_callback(menu, params, _) do
    #    ExUssd.new(fn _, _ ->
    menu
    |> ExUssd.set(data: %{name: params.text})
    |> ExUssd.set(resolve: &create_account_form/2)

    #    end)
  end

  def create_account_form(%{data: %{name: name}} = menu, _) do
    menu
    |> ExUssd.set(title: "Welcome " <> name <> "\nEnter Your 4 digit PIN")
  end

  #  def ussd_callback(menu, %{ text: text } = api_parameters , _meta_data) do
  #    IO.inspect(api_parameters, label: "params>>>")
  #    menu
  #    |> ExUssd.set(data: %{name: text})
  #    |> ExUssd.set(title: "Welcome " <> text <> "\nEnter your 4 digit PIN")
  #  end

  #  def ussd_after_callback(menu, _, _) do
  #    menu
  #    |> ExUssd.set(resolve: &create_account_form/2)
  #  end
  #
  #
  #  def create_account_form(%{ data: %{ name: name } } = menu, api_parameters) do
  #    IO.inspect(api_parameters, label: "params2222>>>")
  #    menu
  #    |> ExUssd.set(title: "Welcome " <> name <> "\nConfirm your 4 digit PIN")
  ##    |> ExUssd.add(ExUssd.new(name: "Enter 4 digit PIN", resolve: fn menu, _ -> menu |> ExUssd.set(title: "Create Account") |> ExUssd.add(ExUssd.new(name: "Confirm PIN", resolve: &create_account/2)) end))
  #  end
  #
  #  def create_account(menu, p) do
  #    IO.inspect p
  #    menu
  #    |> ExUssd.set(title: "Create Account Success", should_close: true)
  #  end
end
