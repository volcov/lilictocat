defmodule Lilictocat.Github do
  @github_api Application.get_env(:lilictocat, :github_api)

  @moduledoc """
  this module consumes the github API, and makes the necessary transformations to use the data
  """

  def name() do
    %{name: name} = @github_api.get_profile()
    name
  end

  def organizations() do
    Enum.map(@github_api.get_organizations(), fn org -> org.login end)
  end

  def organization_repos() do
    organizations()
    |> List.first()
    |> @github_api.get_organization_repos()
    |> Task.async_stream(fn repo -> %{owner: repo.owner.login, name: repo.name} end)
  end

  def open_pull_requests_of_organization() do
    organization_repos()
    |> Task.async_stream(fn {:ok, repo} -> @github_api.get_open_pulls(repo.owner, repo.name) end)
    |> Stream.filter(fn {:ok, pr} -> !Enum.empty?(pr) end)
    |> Stream.flat_map(fn {:ok, pr_list} -> pr_list end)
    |> Stream.map(&convert_pr/1)
  end

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
