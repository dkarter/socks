defmodule SocksWeb.PageController do
  use SocksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
