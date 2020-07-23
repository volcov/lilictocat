defmodule Lilictocat.Github do
  def name do
    {200, %{"name" => name}, _} = Tentacat.Users.me(client())
    name
  end

  defp client do
    {:ok, configs} = Application.fetch_env(:lilictocat, Lilictocat.Github)
    Tentacat.Client.new(%{access_token: Keyword.get(configs, :github_access_token)})
  end
end
