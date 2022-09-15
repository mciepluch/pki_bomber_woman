module Helpers
  class GameHelper

    def self.prepare_game
      map = self.initialize_map
      initialize_walls(map)
      initialize_boxes(map)
      empty_user_places(map)
      set_players(map)
      map
    end

    def self.initialize_map
      map = []
      (0..GameConstants::MAP_SIZE).each do |y_idx|
        map << []
        (0..GameConstants::MAP_SIZE).each do |x_idx|
          map[y_idx] << {
            type: GameConstants::EMPTY_PLACE,
            player: nil,
            bomb: false,
            power: 0,
            explosion: nil
          }
        end
      end
      map
    end

    def self.initialize_walls(map)
      (0..GameConstants::MAP_SIZE).each do |y_idx|
        (0..GameConstants::MAP_SIZE).each do |x_idx|
          map[y_idx][x_idx][:type] = GameConstants::HARD_WALL if (y_idx % 2) == 0 && (x_idx % 2) == 0
        end
      end
      map
    end

    def self.initialize_boxes(map)
      iterator = GameConstants::BOX_COUNT
      while iterator.positive?
        x = rand(GameConstants::MAP_SIZE)
        y = rand(GameConstants::MAP_SIZE)
        if map[y][x][:type] == GameConstants::EMPTY_PLACE
          map[y][x][:type] = GameConstants::BOX_PLACE
          iterator -= 1
        end
      end
    end

    def self.set_players(map)
      (0..GameConstants::MAX_PLAYERS - 1).each do |idx|
        player = GameConstants::STARTING_INFO[idx]
        map[player[:y]][player[:x]][:player] = { sprite: player[:sprite], direction: player[:direction], step: 1 }
      end
    end

    def self.empty_user_places(map)
      map[0][0][:type] = GameConstants::EMPTY_PLACE
      map[0][1][:type] = GameConstants::EMPTY_PLACE
      map[1][0][:type] = GameConstants::EMPTY_PLACE

      map[GameConstants::MAP_SIZE - 1][0][:type] = GameConstants::EMPTY_PLACE
      map[GameConstants::MAP_SIZE - 1][1][:type] = GameConstants::EMPTY_PLACE
      map[GameConstants::MAP_SIZE - 2][0][:type] = GameConstants::EMPTY_PLACE

      map[GameConstants::MAP_SIZE - 1][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE
      map[GameConstants::MAP_SIZE - 1][GameConstants::MAP_SIZE - 2][:type] = GameConstants::EMPTY_PLACE
      map[GameConstants::MAP_SIZE - 2][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE

      map[0][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE
      map[0][GameConstants::MAP_SIZE - 2][:type] = GameConstants::EMPTY_PLACE
      map[1][GameConstants::MAP_SIZE - 1][:type] = GameConstants::EMPTY_PLACE
    end
  end
end