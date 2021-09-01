defmodule SetPinResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, params) do
    menu
    |> ExUssd.set(title: "Welcome " <> params.text <> "\nEnter Your 4 digit PIN")
    |> ExUssd.set(data: %{name: params.text})
  end

  def ussd_callback(%{data: %{name: name}} = menu, %{text: pin}, _) do
    cond do
      String.length(pin) !== 4 ->
        menu
        |> ExUssd.set(error: "The PIN should be 4 digits\n")

      !is_number?(pin) ->
        menu
        |> ExUssd.set(error: "The PIN should be digits only\n")

      true ->
        menu
        |> ExUssd.set(data: %{name: name, pin: pin})
        |> ExUssd.set(resolve: ConfirmPinResolver)
    end
  end

  def is_number?(val) do
    case Integer.parse(val) do
      {_, ""} ->
        true

      _ ->
        false
    end
  end
end
