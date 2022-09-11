class PlayerHelper
  def self.join_player(idx)
    initialize_player(idx)
  end

  def self.initialize_player(idx)
    player = GameConstants::STARTING_INFO[idx]
    {
      position: { x: player[:x], y: player[:y] },
      sprite: player[:sprite],
      done_something: false,
      dead: false,
      ready: true
    }
  end

  def self.validate_player_move(next_map_position, next_position)
    if next_map_position[:player] || next_map_position[:type] == GameConstants::BOX_PLACE ||
      next_map_position[:type] == GameConstants::HARD_WALL || next_map_position[:bomb] || next_position[:y] >= GameConstants::MAP_SIZE ||
      next_position[:y] < 0 || next_position[:x] >= GameConstants::MAP_SIZE || next_position[:x] < 0

      return false
    end

    true
  end
end
