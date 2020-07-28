defmodule Lilictocat.GithubBehaviour do
  @callback get_profile() :: map()
  @callback get_organizations() :: list()
  @callback get_organization_repos(String.t()) :: list()
  @callback get_open_pulls(String.t(), String.t()) :: list()
end
