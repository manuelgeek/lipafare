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

  def is_not_number?(val) do
    case Integer.parse(val) do
      {_, ""} ->
        false

      _ ->
        true
    end
  end
end
