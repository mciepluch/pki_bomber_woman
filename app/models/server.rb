class Server
  include Helpers::ExplosionHelper
  include Helpers::GameHelper
  include Helpers::PlayerHelper
  attr_reader :game

  @@game = []

  def self.prepare_map
      @@game = {
        lobby: [],
        started: false,
        starting: false,
        power_up_counter: 0,
        map: prepare_game
      }
  end

  # def init
  #   @game = {
  #     lobby: [],
  #     started: false,
  #     starting: false,
  #     power_up_counter: 0,
  #     map: prepare_game
  #   }
  # end

  def game_loop
    # @game[:lobby].each_with_index do |player, idx|
    #   #TODO FIX DEAD!
    #   unless player[:dead]
    #     curr_position = get_map_element(player[:position])
    #
    #     #check if user is in explosion
    #     if curr_position[:explosion]
    #
    #       #check if user is inside self explosion
    #
    #       #cbeck whose explosion
    #
    #       remove_player(player, curr_position, idx)
    #       #disconect player!
    #     end
    #   end
    # end
    #
    # #Consider reloging to statistics
    # return if game_ended?
    @game[:map] = DbClient.db_get_map
    ServerChannel.game_update(@game[:map])
    #send game details!
    sleep(0.2)
    game_loop
  end

  def start_game
    Thread.new do
      game_loop
    end
  end

  #TODO: POWERUP LOGIC

  def game_ended?
    return false if game[:lobby].lenght <= 1

    #think about id
    update_win(id) unless game[:lobby].first.nil?
    end_game
    true
  end

  def end_game
    raise "Implement me!"
  end
end
