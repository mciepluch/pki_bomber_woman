class PlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def hello
    broadcast_to(user, { notification: 'Test message' })
  end

  def unsubscribed
    #TODO: Implement
  end
end
