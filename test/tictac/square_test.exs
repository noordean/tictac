defmodule SquareTest do
  use ExUnit.Case

  test "creates square struct successfully" do
    {:ok, square} = Square.new(1, 3)
    assert %Square{row: 1, col: 3} == square
  end

  test "gives error message if row/column is beyond allowed range" do
    {_, error_message} = Square.new(1, 4)
    assert error_message == :invalid_square
  end
end
