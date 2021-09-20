defmodule Utils do
  @moduledoc false

  def check_length(menu, pin) do
    cond do
      String.length(pin) !== 4 ->
        menu
        |> ExUssd.set(error: "The PIN should be 4 digits\n")

      is_not_number?(pin) ->
        menu
        |> ExUssd.set(error: "The PIN should be digits only\n")

      true ->
        :ok
    end
  end

  def check_pin(menu, user, pin) do
    case Bcrypt.check_pass(user, pin) do
      {:ok, user} ->
        :ok

      {:error, _msg} ->
        menu
        |> ExUssd.set(error: "The PIN entered is wrong\n")
    end
  end

  def pin_is_equivalent(menu, pin, c_pin) do
    if String.equivalent?(pin, c_pin) do
      :ok
    else
      menu
      |> ExUssd.set(error: "The PINs should be same\n")
    end
  end

  def is_not_number?(val) do
    case Integer.parse(val) do
      {_, ""} ->
        false

      _ ->
        true
    end
  end
end
