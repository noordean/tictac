defmodule Square do
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  def new(row, col) when row in 1..3 and col in 1..3 do
    {:ok, %Square{row: row, col: col}}
  end

  def new(_, _) do
    {:error, :invalid_square}
  end
end
