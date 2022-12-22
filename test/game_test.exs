defmodule ExMon.GameTest do
  alias ExMon.{Game, Player}
  use ExUnit.Case

  describe "start/2" do
    test "start the game state" do
      player = Player.build("Marco", :punch, :kick, :heal)
      npc = Player.build("NPC", :punch, :kick, :heal)

      assert {:ok, _pid} = Game.start(npc, player)
    end
  end

  describe "info/0" do
    test "return current state of the game" do
      player = Player.build("Marco", :punch, :kick, :heal)
      npc = Player.build("NPC", :punch, :kick, :heal)
      Game.start(npc, player)

      expected_response = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
          name: "NPC"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
          name: "Marco"
        },
        status: :started,
        turn: :player
      }

      assert expected_response == Game.info()
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Marco", :punch, :kick, :heal)
      npc = Player.build("NPC", :punch, :kick, :heal)
      Game.start(npc, player)

      expected_response = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
          name: "NPC"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
          name: "Marco"
        },
        status: :started,
        turn: :player
      }

      assert expected_response == Game.info()

      new_state = %{
        computer: %Player{
          life: 70,
          moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
          name: "NPC"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
          name: "Marco"
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)
      expected_response = %{new_state | turn: :computer, status: :continue}

      assert expected_response == Game.info()
    end
  end

  describe "player/0" do
    test "return the player info" do
      player = Player.build("Marco", :punch, :kick, :heal)
      npc = Player.build("NPC", :punch, :kick, :heal)
      Game.start(npc, player)

      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
        name: "Marco"
      }

      assert expected_response == Game.player()
    end
  end

  describe "turn/0" do
    test "return the current turn" do
      player = Player.build("Marco", :punch, :kick, :heal)
      npc = Player.build("NPC", :punch, :kick, :heal)
      Game.start(npc, player)

      expected_response = :player

      assert expected_response == Game.turn()
    end
  end

  describe "fetch_player/1" do
    test "return the player info declared" do
      player = Player.build("Marco", :punch, :kick, :heal)
      npc = Player.build("NPC", :punch, :kick, :heal)
      Game.start(npc, player)

      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
        name: "Marco"
      }

      assert expected_response == Game.fetch_player(:player)
    end
  end
end
