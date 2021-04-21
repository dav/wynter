defmodule WynterTest do
  use ExUnit.Case
  doctest Wynter

  test "greets the world" do
    assert Wynter.hello() == :world
  end
end
