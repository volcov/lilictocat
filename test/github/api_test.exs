defmodule Lilictocat.Github.APITest do
  use ExUnit.Case, async: true

  import Mox

  setup :verify_on_exit!

  test "returns a profile" do
    Lilictocat.Github.APIMock
    |> expect(:get_profile, fn -> %{"name" => "Liliana Vess"} end)

    assert Lilictocat.Github.APIMock.get_profile() == %{"name" => "Liliana Vess"}
  end
end
