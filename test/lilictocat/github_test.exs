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

      assert Enum.to_list(Github.organization_repos()) == [
               ok: %{owner: "dominaria inc", name: "zoombie"},
               ok: %{owner: "dominaria inc", name: "goblin"}
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

      assert Enum.to_list(Github.open_pull_requests_of_organization()) == [
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

  describe "pull_request_without_review/1" do
    test "pull request with review" do
      expect(Lilictocat.Github.APIMock, :get_reviews_of_pr, fn _project, _number ->
        [%{review_id: 1}, %{review_id: 2}]
      end)

      pull_request = %{project: "dominaria_inc/goblin", number: 21}
      refute Github.pull_request_without_review?(pull_request)
    end

    test "pull request without review" do
      expect(Lilictocat.Github.APIMock, :get_reviews_of_pr, fn _project, _number ->
        []
      end)

      pull_request = %{project: "dominaria_inc/zoombie", number: 666}
      assert Github.pull_request_without_review?(pull_request)
    end
  end
end
