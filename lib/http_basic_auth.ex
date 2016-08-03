defmodule HttpBasicAuth do
  import Plug.Conn, only: [get_req_header: 2,
                           put_resp_header: 3,
                           send_resp: 3,
                           halt: 1]

  @realm "Protected"

  def init(options) do
    Keyword.fetch!(options, :validator)
  end

  def call(conn, validator) do
    conn
    |> get_req_header("authorization")
    |> get_token
    |> credentials
    |> validator.()
    |> respond(conn)
  end

  defp get_token(["Basic " <> auth]), do: auth
  defp get_token(_), do: nil

  defp credentials(token) when is_bitstring(token) do
    Base.decode64!(token) |> String.split(":", parts: 2) |> List.to_tuple
  end
  defp credentials(nil), do: {}

  defp respond(:ok, conn), do: conn
  defp respond(_authorized, conn) do
    conn
    |> put_resp_header("www-authenticate", "Basic realm=\"#{@realm}\"")
    |> send_resp(401, "Unathorized")
    |> halt
  end
end
