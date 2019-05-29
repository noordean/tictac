defmodule StateTest do
  use ExUnit.Case
  alias Tictac.State

  test "creates state struct successfully" do
    {:ok, state} = State.new
    assert %State{} == state
  end

  test "has correct state when game is started" do
    {:ok, state} = State.new
    {:ok, current_state} = State.event(state, {:start_game, :x})

    assert current_state.status == :playing
    assert current_state.current_player == :x
    assert current_state.next_player == :o
  end

  test "has correct state when game is in progress" do
    {:ok, state} = State.new
    {:ok, state} = State.event(state, {:start_game, :x})
    {:ok, current_state} = State.event(state, {:play, :o})

    assert current_state.status == :playing
    assert current_state.current_player == :o
    assert current_state.next_player == :x
  end

  test "throws error if a player tries to play two times simultaneously" do
    {:ok, state} = State.new
    {:ok, state} = State.event(state, {:start_game, :x})
    {:error, error_message} = State.event(state, {:play, :x})

    assert error_message == :not_yet_your_turn
  end

  test "has correct state when game is finished" do
    {:ok, state} = State.new
    {:ok, state} = State.event(state, {:start_game, :x})
    {:ok, state} = State.event(state, {:play, :o})
    {:ok, current_state} = State.event(state, {:finish_game, :o})

    assert current_state.status == :over
    assert current_state.winner == :o
  end

  test "has correct state when game is finished but without a winner" do
    {:ok, state} = State.new
    {:ok, state} = State.event(state, {:start_game, :x})
    {:ok, state} = State.event(state, {:play, :o})
    {:ok, current_state} = State.event(state, {:finish_game, :tie})

    assert current_state.status == :over
    assert current_state.winner == :tie
  end
end
