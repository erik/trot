defmodule Trot.LiveReloadTest do
  use ExUnit.Case, async: true
  import Trot.TestHelper

  test "reloading maintains the requested URL" do
    Path.relative_to_cwd("lib/trot.ex") |> File.touch!
    conn = test_conn(:get, "/foo") |> Trot.LiveReload.call([env: :dev])
    assert conn.state == :sent
    assert conn.status == 302
    assert Plug.Conn.get_resp_header(conn, "location") |> List.first == "/foo"
  end

  test "reloading does not happen outside of dev" do
    Path.relative_to_cwd("lib/trot.ex") |> File.touch!
    conn = test_conn(:get, "/")
    assert Trot.LiveReload.call(conn, [env: :production]) == conn
  end
end
