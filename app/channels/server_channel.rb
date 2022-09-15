class ServerChannel < ApplicationCable::Channel
  after_subscribe :display_players

  def subscribed
    initialize_server if server_empty?
    Server.join_player(current_user.id, current_user.email)
    stream_from "server_channel"
    sleep(1)
    # Server.start_game if server_ready_to_start?
    Server.start_game
  end

  def display_players
    ActionCable.server.broadcast("server_channel", { action: 'players', players: Server.players_info }.to_json)
  end

  def self.game_update(data)
    ActionCable.server.broadcast("server_channel", { action: 'game_update', map: data }.to_json)
  end

  def unsubscribed
    if ActionCable.server.connections.length <= 2
      Server.end_game
      initialize_server
    end
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
    Server.game.empty?
  end

  def server_ready_to_start?
    Server.full_lobby?
  end

  def initialize_server
    Server.prepare_map
  end

  def broadcast(data)
    ActionCable.server.broadcast("server_channel", data)
  end
end
