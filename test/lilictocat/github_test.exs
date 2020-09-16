defmodule Lilictocat.GithubTest do
  use ExUnit.Case

  alias Lilictocat.Github

  import Mox

  setup :verify_on_exit!

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
          %{owner: %{login: "dominaria inc"}, name: "zoombie", archived: true},
          %{owner: %{login: "dominaria inc"}, name: "goblin", archived: false}
        ]
      end)

      assert Enum.to_list(Github.organization_repos()) == [
               ok: %{owner: "dominaria inc", name: "zoombie", archived: true},
               ok: %{owner: "dominaria inc", name: "goblin", archived: false}
             ]
    end
  end

  describe "organization_repos/1" do
    test "with ignore_archived true" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

      expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
        [
          %{owner: %{login: "dominaria inc"}, name: "zoombie", archived: true},
          %{owner: %{login: "dominaria inc"}, name: "goblin", archived: false}
        ]
      end)

      assert Enum.to_list(Github.organization_repos(ignore_archived: true)) == [
               ok: %{owner: "dominaria inc", name: "goblin", archived: false}
             ]
    end

    test "with ignore_archived false" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

      expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
        [
          %{owner: %{login: "dominaria inc"}, name: "zoombie", archived: true},
          %{owner: %{login: "dominaria inc"}, name: "goblin", archived: false}
        ]
      end)

      assert Enum.to_list(Github.organization_repos(ignore_archived: false)) == [
               ok: %{owner: "dominaria inc", name: "zoombie", archived: true},
               ok: %{owner: "dominaria inc", name: "goblin", archived: false}
             ]
    end

    test "with wrong options" do
      assert Enum.to_list(Github.organization_repos(i_think_this_is_a_param: true)) == []
    end
  end

  describe "open_pull_requests_of_organization/1" do
    test "return a list of pr's" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

      expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
        [
          %{owner: %{login: "dominaria inc"}, name: "zoombie", archived: true},
          %{owner: %{login: "dominaria inc"}, name: "goblin", archived: false}
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

    test "return a list of pr's ignoring archived repos" do
      expect(Lilictocat.Github.APIMock, :get_organizations, fn -> [%{login: "dominaria inc"}] end)

      expect(Lilictocat.Github.APIMock, :get_organization_repos, fn _name ->
        [
          %{owner: %{login: "dominaria inc"}, name: "goblin", archived: false}
        ]
      end)

      expect(Lilictocat.Github.APIMock, :get_open_pulls, fn _owner, _name ->
        [
          %{
            created_at: "2020-08-23T17:41:20Z",
            html_url: "https://link_pr.com/2",
            number: 2,
            base: %{repo: %{full_name: "dominaria_inc/goblin"}}
          },
          %{
            created_at: "2020-11-23T17:41:20Z",
            html_url: "https://link_pr.com/4",
            number: 4,
            base: %{repo: %{full_name: "dominaria_inc/goblin"}}
          }
        ]
      end)

      assert Enum.to_list(Github.open_pull_requests_of_organization(ignore_archived: true)) == [
               %{
                 created_at: ~U[2020-08-23 17:41:20Z],
                 link: "https://link_pr.com/2",
                 number: 2,
                 project: "dominaria_inc/goblin"
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
