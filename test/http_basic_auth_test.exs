defmodule HttpBasicAuthTest do
  use ExUnit.Case
  use Plug.Test
  doctest HttpBasicAuth

  defmodule Mounted do
    use Plug.Builder

    plug HttpBasicAuth, validator: &Mounted.is_authorized/1

    plug :index
    defp index(conn, _) do
      conn |> assign(:reached, true) |> send_resp(200, "OK")
    end

    def is_authorized({"user1", "P@ssw0rd"}), do: :ok
    def is_authorized(_), do: :error
  end

  test "asks for username and password" do
    conn = conn(:get, "/") |> Mounted.call([])

    assert conn.status == 401
    [header | _] = get_resp_header(conn, "www-authenticate")
    assert Regex.match? ~r/Basic realm=".*"/, header
    refute conn.assigns[:reached]
  end

  test "log in with incorrect username and password" do
    conn = conn(:get, "/")
           |> put_req_header("authorization", "Basic " <> Base.encode64("admin:hackingin"))
           |> Mounted.call([])

    assert conn.status == 401
    refute conn.assigns[:reached]
  end

  test "log in with bad header" do
    conn = conn(:get, "/")
           |> put_req_header("authorization", "NotSoBasic " <> Base.encode64("user1:P@ssw0rd"))
           |> Mounted.call([])

    assert conn.status == 401
    refute conn.assigns[:reached]
  end

  test "log in with correct username and password" do
    conn = conn(:get, "/")
           |> put_req_header("authorization", "Basic " <> Base.encode64("user1:P@ssw0rd"))
           |> Mounted.call([])

    assert conn.status == 200
    assert conn.assigns[:reached]
  end

  test "requires validator in compile time" do
    try do
      defmodule BrokenPlug do
        use Plug.Builder

        plug HttpBasicAuth
      end
      assert false
    rescue
      e in KeyError -> %KeyError{key: :validator} = e
    end
  end
end
