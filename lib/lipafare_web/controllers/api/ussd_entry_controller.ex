defmodule LipafareWeb.Api.UssdEntryController do
  @moduledoc false
  use LipafareWeb, :controller
  use ExUssd

  def index(conn, _params) do
    request = conn.params

    %{"text" => text, "sessionId" => session_id, "serviceCode" => service_code} = request
    menu = ExUssd.new(name: "Home", resolve: Lipafare.Ussd.InitResolver)

    response =
      ExUssd.goto(
        menu: menu,
        api_parameters: %{
          "service_code" => service_code,
          "session_id" => session_id,
          "text" => text
        }
      )
      |> case do
        {:ok, %{menu_string: menu_string, should_close: false}} ->
          "CON " <> menu_string

        {:ok, %{menu_string: menu_string, should_close: true}} ->
          # End Session
          ExUssd.end_session(session_id: session_id)

          "END " <> menu_string
      end

    text(conn, response)
  end
end
