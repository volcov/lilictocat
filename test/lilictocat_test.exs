defmodule LilictocatTest do
  use ExUnit.Case
  doctest Lilictocat

  import Mox

  setup :verify_on_exit!

  describe "whoami/0" do
    test "returns who am i" do
      expect(Lilictocat.Github.APIMock, :get_profile, fn -> %{name: "Lord Windgrace"} end)

      assert Lilictocat.whoami() == "Lord Windgrace"
    end
  end

  describe "get_my_oldest_opened_pull_request/0" do
    expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

    expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
      [
        %{owner: %{login: "dominaria inc"}, name: "zoombie"},
        %{owner: %{login: "dominaria inc"}, name: "goblin"}
      ]
    end)

    expect(Lilictocat.Github.APIMock, :get_open_pulls, 2, fn _owner, _name ->
      [
        %{
          created_at: "2020-07-23T17:41:20Z",
          html_url: "https://github.com/dominaria/1",
          number: 1,
          base: %{repo: %{full_name: "dominaria_inc/zoombie"}}
        },
        %{
          created_at: "2020-08-23T17:41:20Z",
          html_url: "https://github.com/dominaria/2",
          number: 2,
          base: %{repo: %{full_name: "dominaria_inc/goblin"}}
        }
      ]
    end)

    assert Lilictocat.get_my_oldest_opened_pull_request() == "https://github.com/dominaria/1"
  end
end
