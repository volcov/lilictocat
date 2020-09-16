defmodule Lilictocat do
  alias Lilictocat.Github

  @moduledoc """
    Lilictocat is a simple pull request "finder"

    based on pre-defined rules by the user, it will look for the pull request link in your organization that best fits the rule

    in this alpha version we are only working with one rule, in the future we will have a way to customize your own rules
  """

  @doc """
    returns the link to the oldest pull request that has no views.

  ## Examples

      iex> Lilictocat.get_oldest_pull_request_without_review()
      "https://github.com/dominaria/zoombie/pull/666"

      iex> Lilictocat.get_oldest_pull_request_without_review(ignore_archived: true)
      "https://github.com/dominaria/goblin/pull/132"

  """

  @spec get_oldest_pull_request_without_review(list()) :: String.t()
  def get_oldest_pull_request_without_review(arguments \\ []) do
    Github.open_pull_requests_of_organization(arguments)
    |> Stream.filter(fn pr -> Github.pull_request_without_review?(pr) end)
    |> Enum.min_by(& &1.created_at, DateTime, fn -> %{link: "no pr's to list"} end)
    |> Map.get(:link)
  end
end
