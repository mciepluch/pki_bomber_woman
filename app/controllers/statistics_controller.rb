class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: UserStatisticsSerializer.new(User.all.order(:wins, :kills)).serializable_hash.to_json, status: :ok
  end

  def show
    render json: UserStatisticsSerializer.new(current_user).serializable_hash.to_json, status: :ok
  end
end
