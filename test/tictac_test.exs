defmodule TictacTest do
  use ExUnit.Case

  test "create a mapset of 9 squares" do
    assert MapSet.size(Tictac.squares()) == 9
  end

  test "defaults every board position to empty" do
    board = Tictac.new_board()
    {:ok, square} = Square.new(3, 2)
    assert board[square] == :empty
  end

  test "handles invalid player" do
    board = Tictac.new_board()
    assert Tictac.play_at(board, 2, 2, :u) == {:error, :invalid_player}
  end

  test "handles invalid square" do
    board = Tictac.new_board()
    assert Tictac.play_at(board, 2, 4, :o) == {:error, :invalid_square}
  end

  test "handles occupied position" do
    board = Tictac.new_board()
    assert (Tictac.play_at(board, 2, 2, :o) |> Tictac.play_at(2, 2, :x)) == {:error, :occupied}
  end

  test "plays game correctly" do
    board = Tictac.new_board() |> Tictac.play_at(2, 2, :o)
    {:ok, square} = Square.new(2, 2)
    assert board[square] == :o
  end
end
