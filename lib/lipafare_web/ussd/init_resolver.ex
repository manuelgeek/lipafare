defmodule LipafareWeb.Ussd.InitResolver do
  @moduledoc false
  use ExUssd

  alias LipafareWeb.Ussd
  alias Lipafare.Accounts

  def ussd_init(menu, %{phone_number: phone}) do
    menu
    |> ExUssd.set(title: "LipaFare: Welcome")

#    case get_user(phone) do
#      %{name: name} ->
#        menu
#        |> ExUssd.add(ExUssd.new(name: "Hello " <> name <> ", Login", resolve: Ussd.LoginResolver))
#        |> ExUssd.add(
#          ExUssd.new(
#            name: "Forgot PIN",
#            resolve: fn menu, _ ->
#              menu
#              |> ExUssd.set(
#                title: "Contact us on 0722000000 to get help\nThanks for using LipaFare"
#              )
#              |> ExUssd.set(should_close: true)
#            end
#          )
#        )
#
#      nil ->
#        menu
#        |> ExUssd.add(
#          ExUssd.new(
#            name: "Create Account",
#            resolve: fn menu, _ ->
#              menu
#              |> ExUssd.set(title: "Create Account\nEnter Full Name")
#              |> ExUssd.set(navigate: SetPinResolver)
#            end
#          )
#        )
#
#        #        |> ExUssd.add(ExUssd.new(name: "Create Account", resolve: FullNameResolver))
#    end

            |> ExUssd.add(
              ExUssd.new(fn menu, params ->
              user = get_user(phone)
                if user do
                  menu
                  |> ExUssd.set(name: "Hello "<> user.name <>", Login")
                  |> ExUssd.set(resolve: Ussd.LoginResolver)
                else
                  menu
                  |> ExUssd.set(name: "Create Account")
                  |> ExUssd.set(
                    resolve: fn menu, _ ->
                      menu
                      |> ExUssd.set(title: "Create Account\nEnter Full Name")
                      |> ExUssd.set(navigate: SetPinResolver)
                    end
                  )
                end
              end)
            )
    |> ExUssd.add(ExUssd.new(name: "Lipa Fare", resolve: HomeResolver))
    |> ExUssd.add(
      ExUssd.new(
        name: "About Us",
        resolve: fn menu, _api_parameters ->
          menu
          |> ExUssd.set(title: "About \n This is Lipa Fare USSD App", should_close: true)
        end
      )
    )
  end

  defp get_user(phone) do
    Accounts.get_by(%{"phone" => phone})
  end
end
