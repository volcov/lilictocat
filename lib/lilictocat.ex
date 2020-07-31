defmodule Lilictocat do
  alias Lilictocat.Github

  @moduledoc """
  coming soon
  """

  def whoami do
    Github.name()
  end

  def my_open_pull_requests do
    Github.open_pull_requests_of_organization()
  end

  def get_my_oldest_opened_pull_request do
    my_open_pull_requests()
    |> Enum.min_by(& &1.created_at, DateTime)
    |> Map.get(:link)
  end
end
