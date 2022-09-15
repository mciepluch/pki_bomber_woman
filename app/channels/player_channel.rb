class PlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_channel_#{current_user.id}"
    idx = Server.game.empty? ? 0 : Server.game[:lobby]&.length
    ActionCable.server.broadcast("player_channel_#{current_user.id}", { action: 'player_idx', idx: idx }.to_json)
  end


  def self.player_died(player_index)
    ActionCable.server.broadcast("player_channel_#{player_index}", { action: 'player_died'}.to_json)
  end

  def unsubscribed
  end
end
