defmodule Lilictocat.GithubTest do
  use ExUnit.Case

  alias Lilictocat.Github

  import Mox

  setup :verify_on_exit!

  describe "name/0" do
    test "returns a name" do
      expect(Lilictocat.Github.APIMock, :get_profile, fn -> %{"name" => "Liliana Vess"} end)

      assert Github.name() == "Liliana Vess"
    end
  end

  describe "organizations/0" do
    test "returns a single organization" do
      assert Github.organizations() == "dominaria inc"
    end
  end
end
