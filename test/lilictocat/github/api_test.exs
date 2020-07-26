defmodule Lilictocat.Github.APITest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "get_profile/0" do
    test "returns a profile" do
      expect(Lilictocat.Github.APIMock, :get_profile, fn ->
        %{"name" => "Liliana Vess", "id" => 1, "email" => "lililinda@benalia.com"}
      end)

      profile = Lilictocat.Github.APIMock.get_profile()

      assert Map.get(profile, "name") == "Liliana Vess"
      assert Map.get(profile, "id") == 1
      assert Map.get(profile, "email") == "lililinda@benalia.com"
    end
  end
end
