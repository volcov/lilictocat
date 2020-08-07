defmodule Lilictocat do
  alias Lilictocat.Github

  @moduledoc """
  coming soon
  """

  def get_oldest_pull_request_without_review do
    Github.open_pull_requests_of_organization()
    |> Stream.filter(fn pr -> Github.pull_request_without_review?(pr) end)
    |> Enum.min_by(& &1.created_at, DateTime)
    |> Map.get(:link)
  end
end
