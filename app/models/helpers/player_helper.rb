class PlayerHelper
  def self.join_player(idx, db_index)
    initialize_player(idx, db_index)
  end

  def self.initialize_player(idx, db_index)
    player = GameConstants::STARTING_INFO[idx]
    {
      position: { x: player[:x], y: player[:y] },
      sprite: player[:sprite],
      done_something: false,
      kills: 0,
      dead: false,
      ready: true,
      won: 0,
      db_index: db_index
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

  def self.update_db_user(player)
    user = User.find_by(id: player[:db_index])
    user.games_played += 1
    user.kills += player[:kills]
    user.wins += player[:won]
    user.save
  end

  def self.direction(move)
    direction = if move == { x: 0, y: 1 }
                  'DOWN'
                elsif move == { x: 0, y: -1 }
                  'UP'
                elsif move == { x: 1, y: 0 }
                  'RIGHT'
                else
                  'LEFT'
                end
  end
end
