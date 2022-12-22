defmodule ExMonTest do
  alias ExMon.Player
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "create_player/4" do
    test "return a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
        name: "Marco"
      }

      assert expected_response == ExMon.create_player("Marco", :kick, :punch, :heal)
    end
  end

  describe "start_game/1" do
    test "return a message when the game is started" do
      player = Player.build("Marco", :punch, :kick, :heal)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "The game is started!"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("Marco", :punch, :kick, :heal)

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      :ok
    end

    test "do the move if the movement is valid" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:kick)
        end)

      assert messages =~ "The player attacked the computer"
      assert messages =~ "It's computer turn"
      assert messages =~ "It's player turn"
      assert messages =~ "status: :continue"
    end

    test "when the move is invalid" do
      messages =
      capture_io(fn ->
        ExMon.make_move(:wrong)
      end)

    assert messages =~ "Invalid move: wrong"
    end
  end
end
