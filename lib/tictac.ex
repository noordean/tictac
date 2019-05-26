defmodule Tictac do
  def squares do
    for row <- 1..3, col <- 1..3, into: %MapSet{}, do: Square.new(row, col)
  end

  def new_board do
    for s <- squares(), into: %{}, do: {s, :empty}
  end
end
