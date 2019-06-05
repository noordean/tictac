defmodule Tictac do
  alias Tictac.{State, CLI}

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

  def start_game do
    {:ok, state} = State.new(CLI)
    selected_player = state.ui.select_player
    {:ok, state} = State.event(state, {:start_game, selected_player})

    play_position = state.ui.play_position
    current_board = play_at(state.board, play_position.row, play_position.col, selected_player)
    state = %{state | board: current_board}
    state.ui.display_board(state.board)
    handle_play(state)
  end

  def handle_play(%{status: :playing} = state) do
    selected_player = state.ui.select_player
    play_position = state.ui.play_position
    current_board = play_at(state.board, play_position.row, play_position.col, selected_player)
    state = %{state | board: current_board}

    {:ok, state} = if game_over?(state.board) do
      case winner(state.board) do
        "" ->
          IO.puts "Game Over... That was a draw!"
          State.event(state, {:finish_game, :tie})
        player ->
          IO.puts "Game Over... #{player} won!"
          State.event(state, {:finish_game, String.to_atom(player)})
      end
    else
      State.event(state, {:play, selected_player})
    end
    state.ui.display_board(state.board)
    handle_play(state)
  end

  def game_over?(board) do
    empties = for {pos, value} <- board, value == :empty, do: value
    length(empties) == 0
  end

  def winner(board) do
    postion_points = [
      [%{row: 1, col: 1}, %{row: 1, col: 2}, %{row: 1, col: 3}],
      [%{row: 1, col: 1}, %{row: 2, col: 2}, %{row: 3, col: 3}],
      [%{row: 1, col: 1}, %{row: 2, col: 1}, %{row: 3, col: 1}],
      [%{row: 2, col: 1}, %{row: 2, col: 2}, %{row: 2, col: 3}],
      [%{row: 3, col: 1}, %{row: 3, col: 2}, %{row: 3, col: 3}],
      [%{row: 1, col: 2}, %{row: 2, col: 2}, %{row: 3, col: 2}],
      [%{row: 1, col: 3}, %{row: 2, col: 3}, %{row: 3, col: 3}],
      [%{row: 1, col: 3}, %{row: 2, col: 2}, %{row: 3, col: 1}]
    ]
    lines = for point <- postion_points, do: diagonal_values(board, point)
    won_line = Enum.find(lines, &line_won?(&1))
    won_line |> Enum.at(0) |> to_string
  end

  def diagonal_values(board, points) do
    positions = for point <- points, do: %Square{col: point.col, row: point.row}
    for {pos, val} <- board, Enum.any?(positions, &(&1 == pos)), do: val
  end

  def line_won?(line) do
    first_element = line |> Enum.at(0)
    Enum.all?(line, &(&1 == first_element))
  end
end
