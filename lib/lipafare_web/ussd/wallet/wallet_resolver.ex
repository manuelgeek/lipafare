defmodule WalletResolver do
  @moduledoc false

  use ExUssd

  def ussd_init(menu, _) do
    menu
    |> ExUssd.set(title: "Wallet")
    |> ExUssd.add(ExUssd.new(name: "Top up Wallet", resolve: TopUpResolver))
    |> ExUssd.add(ExUssd.new(name: "Check Balance", resolve: &check_balance/2))
  end


  def check_balance(menu, _) do
    menu
    |> ExUssd.set(title: "Coming soon") |> ExUssd.set(should_close: true)
  end
end
