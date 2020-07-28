defmodule Lilictocat.GithubTest do
  use ExUnit.Case

  alias Lilictocat.Github

  import Mox

  setup :verify_on_exit!

  describe "name/0" do
    test "returns a name" do
      expect(Lilictocat.Github.APIMock, :get_profile, fn -> %{name: "Liliana Vess"} end)

      assert Github.name() == "Liliana Vess"
    end
  end

  describe "get_organizations/0" do
    test "returns a list of organizations" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)
      assert Github.organizations() == ["dominaria inc"]
    end
  end
end
