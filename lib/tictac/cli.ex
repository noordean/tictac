defmodule Tictac.CLI do
  def select_player do
    IO.gets("Who is playing now ? ")
      |> String.trim
      |> String.to_atom
  end

  def play_position do
    row = IO.gets("Row: ") |> String.trim |> String.to_integer
    col = IO.gets("Col: ") |> String.trim |> String.to_integer
    %Square{row: row, col: col}
  end

  def display_board(board) do
    IO.puts """
      #{value_at_position(board,1, 1)} | #{value_at_position(board,1, 2)} | #{value_at_position(board,1, 3)}
      ---------
      #{value_at_position(board,2, 1)} | #{value_at_position(board,2, 2)} | #{value_at_position(board,2, 3)}
      ---------
      #{value_at_position(board,3, 1)} | #{value_at_position(board,3, 2)} | #{value_at_position(board,3, 3)}
    """
  end

  def value_at_position(board, row, col) do
    [pos_value] = for {pos, value} <- board, pos == %Square{col: col, row: row}, do: value
    if pos_value == :empty do
      " "
    else
      to_string(pos_value)
    end
  end
end
