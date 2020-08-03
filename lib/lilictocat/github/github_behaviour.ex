defmodule Lilictocat.GithubBehaviour do
  @moduledoc false

  @callback get_profile() :: map()
  @callback get_organizations() :: list()
  @callback get_organization_repos(String.t()) :: list()
  @callback get_open_pulls(String.t(), String.t()) :: list()
  @callback get_reviews_of_pr(String.t(), integer()) :: list()
end
