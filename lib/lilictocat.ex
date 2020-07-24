defmodule Lilictocat do
  alias Lilictocat.Github

  def whoami do
    Github.name()
  end
end
