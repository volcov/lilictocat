defmodule Lilictocat.Github do
  @github_api Application.get_env(:lilictocat, :github_api)

  @moduledoc """
  this module consumes the github API, and makes the necessary transformations to use the data
  """

  @doc """
  returns a list of organiztions

  ## Examples
     iex> Lilictocat.Github.organizations()
     ["dominaria inc"]
  """
  @spec organizations() :: list()
  def organizations() do
    Enum.map(@github_api.get_organizations(), fn org -> org.login end)
  end

  @doc """
  returns a list of repositories

  ## Examples
     iex> Lilictocat.Github.organization_repos()
     [
       %{owner: %{login: "dominaria inc"}, name: "zoombie"},
       %{owner: %{login: "dominaria inc"}, name: "goblin"}
     ]
  """
  @spec organization_repos() :: list()
  def organization_repos() do
    organizations()
    |> List.first()
    |> @github_api.get_organization_repos()
    |> Task.async_stream(fn repo -> %{owner: repo.owner.login, name: repo.name} end)
  end

  @doc """
  returns a list of pull requests with status open

  ## Examples
     iex> Lilictocat.Github.open_pull_requests_of_organization()
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
  """
  @spec open_pull_requests_of_organization() :: list()
  def open_pull_requests_of_organization() do
    organization_repos()
    |> Task.async_stream(fn {:ok, repo} -> @github_api.get_open_pulls(repo.owner, repo.name) end)
    |> Stream.filter(fn {:ok, pr} -> !Enum.empty?(pr) end)
    |> Stream.flat_map(fn {:ok, pr_list} -> pr_list end)
    |> Stream.map(&convert_pr/1)
  end

  @doc """
  returns a boolean to indicate if the pull request has any review

  ## Examples
     iex> Lilictocat.Github.pull_request_without_review(%{project: "dominaria_inc/goblin", number: 21})
     true
  """
  @spec pull_request_without_review?(map()) :: boolean()
  def pull_request_without_review?(%{project: project, number: number}) do
    Enum.empty?(@github_api.get_reviews_of_pr(project, number))
  end

  defp convert_pr(pr) do
    %{
      project: pr.base.repo.full_name,
      number: pr.number,
      link: pr.html_url,
      created_at: parse_date(pr.created_at)
    }
  end

  defp parse_date(string) do
    {:ok, datetime, 0} = DateTime.from_iso8601(string)
    datetime
  end
end
