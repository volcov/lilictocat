defmodule Lilictocat.Github.API do
  @behaviour Lilictocat.GithubBehaviour

  @moduledoc false

  def get_organizations do
    {200, orgs, _} = Tentacat.Organizations.list_mine(client())
    orgs
  end

  def get_organization_repos(organization_name) do
    {200, org_repos, _} = Tentacat.Repositories.list_orgs(client(), organization_name)
    org_repos
  end

  def get_open_pulls(organization_name, repo_name) do
    {200, pulls, _} =
      Tentacat.Pulls.filter(client(), organization_name, repo_name, %{state: "open"})

    pulls
  end

  def get_reviews_of_pr(project, pr_number) do
    [organization, repo] = String.split(project, "/")

    {200, reviews, _} = Tentacat.Pulls.Reviews.list(client(), organization, repo, pr_number)
    reviews
  end

  defp client do
    {:ok, configs} = Application.fetch_env(:lilictocat, Lilictocat.Github)
    Tentacat.Client.new(%{access_token: Keyword.get(configs, :github_access_token)})
  end
end
