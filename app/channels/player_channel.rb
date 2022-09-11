class PlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_for "player_channel_#{current_user.id}"
    sleep 3
    ActionCable.server.broadcast("player_channel_#{current_user.id}", { action: 'player_idx', idx: ActionCable.server.connections.length - 1 }.to_json)
  end

  def test
    ActionCable.server.broadcast("player_channel_#{current_user.id}", { action: 'player_idx', idx: ActionCable.server.connections.length - 1 }.to_json)
  end
end
