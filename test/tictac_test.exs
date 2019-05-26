defmodule TictacTest do
  use ExUnit.Case

  test "create a mapset of 9 squares" do
    assert MapSet.size(Tictac.squares()) == 9
  end

  test "defaults every board position to empty" do
    board = Tictac.new_board()
    square = Square.new(3, 2)
    assert board[square] == :empty
  end
end
