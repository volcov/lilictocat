defmodule Lilictocat.Github do
  @github_api Application.get_env(:lilictocat, :github_api)

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
    |> Enum.map(fn repo -> %{owner: repo.owner.login, name: repo.name} end)
  end

  def open_pull_requests_of_organization() do
    organization_repos()
    |> Enum.map(fn repo -> @github_api.get_open_pulls(repo.owner, repo.name) end)
    |> Enum.filter(&(!Enum.empty?(&1)))
    |> List.flatten()
    |> Enum.map(& &1.url)
  end
end
