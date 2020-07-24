defmodule Lilictocat.Github.API do
  def get_profile do
    {200, map, _} = Tentacat.Users.me(client())
    map
  end

  defp client do
    {:ok, configs} = Application.fetch_env(:lilictocat, Lilictocat.Github)
    Tentacat.Client.new(%{access_token: Keyword.get(configs, :github_access_token)})
  end
end
