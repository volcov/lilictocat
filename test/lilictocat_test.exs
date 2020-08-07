defmodule LilictocatTest do
  use ExUnit.Case
  doctest Lilictocat

  import Mox

  setup :verify_on_exit!

  describe "get_oldest_pull_request_without_review/0" do
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
          html_url: "https://github.com/dominaria/zoombie/pull/666",
          number: 666,
          base: %{repo: %{full_name: "dominaria_inc/zoombie"}}
        },
        %{
          created_at: "2020-09-23T17:41:20Z",
          html_url: "https://github.com/dominaria/zoombie/pull/669",
          number: 669,
          base: %{repo: %{full_name: "dominaria_inc/zoombie"}}
        }
      ]
    end)

    expect(Lilictocat.Github.APIMock, :get_open_pulls, fn _owner, _name ->
      [
        %{
          created_at: "2020-08-23T17:41:20Z",
          html_url: "https://github.com/dominaria/goblin/pull/132",
          number: 132,
          base: %{repo: %{full_name: "dominaria_inc/goblin"}}
        }
      ]
    end)

    expect(Lilictocat.Github.APIMock, :get_reviews_of_pr, fn _project, _number ->
      []
    end)

    expect(Lilictocat.Github.APIMock, :get_reviews_of_pr, fn _project, _number ->
      [%{review_id: 1}, %{review_id: 2}]
    end)

    expect(Lilictocat.Github.APIMock, :get_reviews_of_pr, fn _project, _number ->
      []
    end)

    assert Lilictocat.get_oldest_pull_request_without_review() ==
             "https://github.com/dominaria/zoombie/pull/666"
  end
end
