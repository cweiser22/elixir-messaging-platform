defmodule CowboyChatNodeTest do
  use ExUnit.Case
  doctest CowboyChatNode

  test "greets the world" do
    assert CowboyChatNode.hello() == :world
  end
end
