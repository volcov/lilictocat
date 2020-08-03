defmodule Lilictocat do
  alias Lilictocat.Github

  @moduledoc """
  coming soon
  """

  def whoami do
    Github.name()
  end

  def get_my_oldest_opened_pull_request do
    Github.open_pull_requests_of_organization()
    |> Enum.min_by(& &1.created_at, DateTime)
    |> Map.get(:link)
  end

  def get_oldest_pull_request_without_review do
    Github.open_pull_requests_of_organization()
    |> Enum.filter(fn pr -> Github.pull_request_without_review?(pr) end)
    |> Enum.min_by(& &1.created_at, DateTime)
    |> Map.get(:link)
  end
end
