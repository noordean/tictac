defmodule Tictac.State do
  alias __MODULE__
  defstruct [status: :initial, board: Tictac.new_board, current_player: nil, next_player: nil, winner: nil]

  def new do
    {:ok, %State{}}
  end

  def event(%State{status: :initial} = state, {:start_game, player}) do
    case Tictac.check_player(player) do
      {:ok, player} -> {:ok, %State{ state | status: :playing, current_player: player, next_player: other_player(player)}}
      _ -> {:error, :invalid_player}
    end
  end

  def event(%State{status: :playing} = state, {:play, player}) do
    if state.current_player != player do
      case Tictac.check_player(player) do
        {:ok, player} -> {:ok, %State{ state | current_player: player, next_player: other_player(player)}}
        _ -> {:error, :invalid_player}
      end
    else
      {:error, :not_yet_your_turn}
    end
  end

  def event(%State{status: :playing} = state, {:finish_game, :tie}) do
    {:ok, %State{ state | status: :over, current_player: nil, next_player: nil, winner: :tie}}
  end

  def event(%State{status: :playing} = state, {:finish_game, player}) do
    case Tictac.check_player(player) do
      {:ok, player} -> {:ok, %State{ state | status: :over, current_player: nil, next_player: nil, winner: player}}
      _ -> {:error, :invalid_player}
    end
  end

  def event(state, action) do
    {:error, :invalid_state_transition}
  end

  defp other_player(player) do
    case player do
      :x -> :o
      :o -> :x
    end
  end
end
