class PlayerHelper
  def self.join_player(idx, db_index, username)
    initialize_player(idx, db_index, username)
  end

  def self.initialize_player(idx, db_index, username)
    player = GameConstants::STARTING_INFO[idx]
    {
      position: { x: player[:x], y: player[:y] },
      sprite: player[:sprite],
      done_something: false,
      kills: 0,
      dead: false,
      ready: true,
      won: 0,
      username: username,
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

  def self.step(curr_step, prev_direction, curr_direction)
    return 1 if prev_direction != curr_direction

    (curr_step + 1) % 3
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
