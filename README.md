# HttpBasicAuth

HTTP basic authentication as a Plug module.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `http_basic_auth` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:http_basic_auth, "~> 0.1.0"}]
    end
    ```

  2. Ensure `http_basic_auth` is started before your application:

    ```elixir
    def application do
      [applications: [:http_basic_auth]]
    end
    ```

