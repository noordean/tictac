defmodule Tictac do
  def squares do
    for row <- 1..3, col <- 1..3, into: %MapSet{}, do: Square.new(row, col)
  end

  def new_board do
    for {:ok, s} <- squares(), into: %{}, do: {s, :empty}
  end

  def play_at(board, row, col, player) do
    with {:ok, current_player} <- check_player(player),
      {:ok, square_position} <- Square.new(row, col),
      {:ok, current_board} <- play(board, square_position, current_player),
    do: current_board
  end

  def check_player(player) do
    case player do
      :o -> {:ok, player}
      :x -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  def play(board, square_position, player) do
    case board[square_position] do
      :empty -> {:ok, %{ board | square_position => player }}
      :x -> {:error, :occupied}
      :o -> {:error, :occupied}
      _ -> {:error, :invalid_position}
    end
  end
end
