defmodule LilictocatTest do
  use ExUnit.Case
  doctest Lilictocat

  import Mox

  setup :verify_on_exit!

  describe "whoami/0" do
    test "returns who am i" do
      expect(Lilictocat.Github.APIMock, :get_profile, fn -> %{"name" => "Lord Windgrace"} end)

      assert Lilictocat.whoami() == "Lord Windgrace"
    end
  end
end
