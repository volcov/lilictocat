defmodule Lilictocat.GithubBehaviour do
  @callback get_profile() :: map()
  @callback get_organizations() :: list()
end
