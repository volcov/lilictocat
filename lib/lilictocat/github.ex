defmodule Lilictocat.Github do
  @github_api Application.get_env(:lilictocat, :github_api)

  def name do
    %{"name" => name} = @github_api.get_profile()
    name
  end
end
