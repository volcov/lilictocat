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
    test "return a list of pr's" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

      expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
        [
          %{owner: %{login: "dominaria inc"}, name: "zoombie"},
          %{owner: %{login: "dominaria inc"}, name: "goblin"}
        ]
      end)

      expect(Lilictocat.Github.APIMock, :get_open_pulls, fn _owner, _name ->
        [
          %{
            created_at: "2020-07-23T17:41:20Z",
            html_url: "https://link_pr.com/1",
            number: 1,
            base: %{repo: %{full_name: "dominaria_inc/zoombie"}}
          },
          %{
            created_at: "2020-08-23T17:41:20Z",
            html_url: "https://link_pr.com/2",
            number: 2,
            base: %{repo: %{full_name: "dominaria_inc/goblin"}}
          }
        ]
      end)

      expect(Lilictocat.Github.APIMock, :get_open_pulls, fn _owner, _name ->
        [
          %{
            created_at: "2020-09-23T17:41:20Z",
            html_url: "https://link_pr.com/3",
            number: 3,
            base: %{repo: %{full_name: "dominaria_inc/zoombie"}}
          },
          %{
            created_at: "2020-11-23T17:41:20Z",
            html_url: "https://link_pr.com/4",
            number: 4,
            base: %{repo: %{full_name: "dominaria_inc/goblin"}}
          }
        ]
      end)

      assert Github.open_pull_requests_of_organization() == [
               %{
                 created_at: ~U[2020-07-23 17:41:20Z],
                 link: "https://link_pr.com/1",
                 number: 1,
                 project: "dominaria_inc/zoombie"
               },
               %{
                 created_at: ~U[2020-08-23 17:41:20Z],
                 link: "https://link_pr.com/2",
                 number: 2,
                 project: "dominaria_inc/goblin"
               },
               %{
                 created_at: ~U[2020-09-23 17:41:20Z],
                 link: "https://link_pr.com/3",
                 number: 3,
                 project: "dominaria_inc/zoombie"
               },
               %{
                 created_at: ~U[2020-11-23 17:41:20Z],
                 link: "https://link_pr.com/4",
                 number: 4,
                 project: "dominaria_inc/goblin"
               }
             ]
    end
  end
end
