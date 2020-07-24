defmodule Lilictocat.Github do
  alias Lilictocat.Github.API, as: GithubAPI

  def name do
    %{"name" => name} = GithubAPI.get_profile()
    name
  end
end
