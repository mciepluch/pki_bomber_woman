module Helpers::GameHelper

  def prepare_game
    initialize_map
    initialize_walls
    # initialize_boxes
    empty_user_places
    set_players
    DbClient.db_set_map(@map)
    #TODO: SENDING USER NAMES
    #
    #    const playersInGame = players.map((p) => ({
    #       username: p.socket.user.username,
    #       color: p.color,
    #     }));
    #
    #     io.to("game").emit("playersInGame", playersInGame);
    #
    #     startGameLoop();
    @map
  end

  def get_map_element(element)
    @game[:map][element[:y]][element[:x]]
  end

  def initialize_map
    @map = []
    (0..GameConstants::MAP_SIZE).each do |y_idx|
      @map << []
      (0..GameConstants::MAP_SIZE).each do |x_idx|
        @map[y_idx] << {
          type: GameConstants::EMPTY_PLACE,
          player: nil,
          bomb: false,
          power: 0,
          explosion: nil
        }
      end
    end
  end

  def initialize_walls
    (0..GameConstants::MAP_SIZE).each do |y_idx|
      (0..GameConstants::MAP_SIZE).each do |x_idx|
        @map[y_idx][x_idx][:type] = GameConstants::HARD_WALL if !((y_idx + 1) % 2) && !((x_idx + 1) % 2)
      end
    end
  end

  def initialize_boxes
    iterator = GameConstants::BOX_COUNT
    while iterator
      x = rand(GameConstants::MAP_SIZE)
      y = rand(GameConstants::MAP_SIZE)
      if @map[y][x][:type] == GameConstants::EMPTY_PLACE
        @map[y][x][:type] = GameConstants::BOX_PLACE
        --iterator
      end
    end
  end

  def set_players
    (0..GameConstants::MAX_PLAYERS - 1).each do |idx|
      player = GameConstants::STARTING_INFO[idx]
      @map[player[:y]][player[:x]][:player] = player[:sprite]
      # @game[:lobby][idx][:position] = { y: player[:y], x: player[:x] }
      # @game[:lobby][idx][:sprite] = player[:sprite]
    end
  end

  def empty_user_places
    @map[0][0][:type] = GameConstants::EMPTY_PLACE
    @map[0][1][:type] = GameConstants::EMPTY_PLACE
    @map[1][0][:type] = GameConstants::EMPTY_PLACE

    @map[GameConstants::MAP_SIZE - 1][0][:type] = GameConstants::EMPTY_PLACE
    @map[GameConstants::MAP_SIZE - 1][1][:type] = GameConstants::EMPTY_PLACE
    @map[GameConstants::MAP_SIZE - 2][0][:type] = GameConstants::EMPTY_PLACE

    @map[GameConstants::MAP_SIZE - 1][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE
    @map[GameConstants::MAP_SIZE - 1][GameConstants::MAP_SIZE - 2][:type] = GameConstants::EMPTY_PLACE
    @map[GameConstants::MAP_SIZE - 2][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE

    @map[0][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE
    @map[0][GameConstants::MAP_SIZE - 2][:type] = GameConstants::EMPTY_PLACE
    @map[1][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE
  end
end
