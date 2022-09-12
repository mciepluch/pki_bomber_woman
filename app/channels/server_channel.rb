class ServerChannel < ApplicationCable::Channel
  def subscribed
    initialize_server if server_empty?
    Server.join_player(current_user.id)
    stream_from "server_channel"
    sleep(1)
    Server.start_game if server_empty?
  end

  def self.game_update(data)
    ActionCable.server.broadcast("server_channel", { action: 'game_update', map: data }.to_json)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def game_map
    broadcast(@server.game[:map])
  end

  def move_player(data)
    player_idx = data["player"]
    player_destination = { x: data['x'], y: data['y'] }

    Server.move_player(player_idx, player_destination)
  end

  def set_bomb(data)
    player_idx = data["player"]
    bomb_destination = { x: data['x'], y: data['y'] }

    Thread.new do
      Server.bomb_setup(bomb_destination, player_idx)
    end
  end

  private

  def players_in_the_game
    broadcast(true)
  end

  def self.game_ended
    ActionCable.server.broadcast("server_channel", { action: 'game_ended' }.to_json)
  end

  def server_empty?
    Server.game.empty? || !Server.game[:started]
  end

  def initialize_server
    Server.prepare_map
  end

  def broadcast(data)
    ActionCable.server.broadcast("server_channel", data)
  end
end
