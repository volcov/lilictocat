defmodule LilictocatTest do
  use ExUnit.Case
  doctest Lilictocat

  test "greets the world" do
    assert Lilictocat.hello() == :world
  end
end
