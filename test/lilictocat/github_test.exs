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

  describe "organizations/0" do
    test "returns a list of organizations" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)
      assert Github.organizations() == ["dominaria inc"]
    end
  end

  describe "organization_repos/0" do
    test "return a list of repos" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

      expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
        [
          %{owner: %{login: "dominaria inc"}, name: "zoombie"},
          %{owner: %{login: "dominaria inc"}, name: "goblin"}
        ]
      end)

      assert Github.organization_repos() == [
               %{owner: "dominaria inc", name: "zoombie"},
               %{owner: "dominaria inc", name: "goblin"}
             ]
    end
  end

  describe "open_pull_requests_of_organization/0" do
    test "return a list of urls" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

      expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
        [
          %{owner: %{login: "dominaria inc"}, name: "zoombie"},
          %{owner: %{login: "dominaria inc"}, name: "goblin"}
        ]
      end)

      expect(Lilictocat.Github.APIMock, :get_open_pulls, fn _owner, _name ->
        [
          %{url: "https://link_pr.com/1"},
          %{url: "https://link_pr.com/2"}
        ]
      end)

      expect(Lilictocat.Github.APIMock, :get_open_pulls, fn _owner, _name ->
        [
          %{url: "https://link_pr.com/3"},
          %{url: "https://link_pr.com/4"}
        ]
      end)

      assert Github.open_pull_requests_of_organization() == [
               "https://link_pr.com/1",
               "https://link_pr.com/2",
               "https://link_pr.com/3",
               "https://link_pr.com/4"
             ]
    end
  end
end
