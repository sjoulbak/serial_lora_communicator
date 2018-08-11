defmodule SerialLoraCommunicatorTest do
  use ExUnit.Case
  doctest SerialLoraCommunicator

  test "greets the world" do
    assert SerialLoraCommunicator.hello() == :world
  end
end
