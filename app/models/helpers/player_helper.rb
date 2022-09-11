module Helpers::PlayerHelper
  def join_player
    @game[:lobby] << initialize_player(@game[:lobby].length)
  end

  def initialize_player(idx)
    player = GameConstants::STARTING_INFO[idx]
    {
      position: { x: player[:x], y: player[:y] },
      sprite: player[:sprite],
      done_something: false,
      dead: false,
      ready: true
    }
  end

  def move_player(player_index, destination)
    @game[:map] = DbClient.db_get_map
    player = @game[:lobby][player_index]
    next_pos = get_new_position(player, destination)
    return unless validate_player_move(next_pos)
    Server.board

    update_map_position(player[:position], next_pos, player[:sprite])
    assign_new_position_to_player(player, next_pos)
    DbClient.db_set_map(@game[:map])
  end

  def assign_new_position_to_player(player, next_position)
    player[:position] = next_position
  end

  def get_new_position(player, destination)
    prev = player[:position]
    { x: prev[:x] + destination[:x], y: prev[:y] - destination[:y] }
  end

  # def remove_player(player, player_position, player_idx)
  #   byebug
  #   @game[:map] = DbClient.db_get_map
  #   player[:dead] = true
  #   player_position[:position] = nil
  #   player_position[:player] = nil
  #   ServerChannel.player_died(player_idx)
  #   DbClient.db_set_map(@game[:map])
  # end

  def update_map_position(source, destination, sprite)
    get_map_element(source)[:player] = nil
    get_map_element(destination)[:player] = sprite
  end

  def validate_player_move(next_position)
    destination = get_map_element(next_position)

    if destination[:player] || destination[:type] == GameConstants::BOX_PLACE ||
       destination[:type] == GameConstants::HARD_WALL || destination[:bomb] || next_position[:y] >= GameConstants::MAP_SIZE ||
      next_position[:y] < 0 || next_position[:x] >= GameConstants::MAP_SIZE || next_position[:x] < 0

      return false
    end

    true
  end
end
