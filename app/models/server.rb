require 'helpers/game_helper'
require 'helpers/player_helper'

class Server
  attr_reader :game

  @@game = []

  def self.game
    @@game
  end

  def self.prepare_map
      @@game = {
        lobby: [],
        started: false,
        starting: false,
        power_up_counter: 0,
        map: GameHelper.prepare_game,
        killed: 0
      }
  end

  def self.join_player(db_index)
    @@game[:lobby].push(PlayerHelper.join_player(@@game[:lobby].length, db_index))
  end

  # --------------- Move Player Logic ---------------------------

  def self.move_player(player_index, destination)
    player = @@game[:lobby][player_index]
    next_pos = get_new_position(player, destination)
    next_map_pos = get_map_element(next_pos)
    return unless PlayerHelper.validate_player_move(next_map_pos, next_pos)

    update_map_position(player[:position], next_pos, player[:sprite])
    assign_new_position_to_player(player, next_pos)
  end

  def self.update_map_position(source, destination, sprite)
    get_map_element(source)[:player] = nil
    get_map_element(destination)[:player] = sprite
  end

  def self.assign_new_position_to_player(player, next_position)
    player[:position] = next_position
  end



  # --------------- Move Player Logic END ----------------------
  # --------------- Player Logic -------------------------------

  def self.remove_player(player, player_position, player_idx)
    player[:dead] = true
    player_position[:position] = nil
    player_position[:player] = nil
    PlayerChannel.player_died(player[:db_index])
    add_kill(player_position[:explosion]) if player_idx != player_position[:explosion]
    PlayerHelper.update_db_user(player)
  end

  # --------------- Player Logic END ---------------------------

  # --------------- Explosion Logic ----------------------------

  def self.bomb_setup(destination, player_idx)
    player = @@game[:lobby][player_idx]
    bomb_pos = get_new_position(player, destination)
    bomb_map_pos = get_map_element(bomb_pos)
    return unless PlayerHelper.validate_player_move(bomb_map_pos, bomb_pos)

    add_bomb(bomb_map_pos)

    sleep 4
    add_explosion(bomb_pos, player_idx)

    sleep 2
    #Removal of explosions
    remove_explosion(bomb_pos)
  end

  def self.add_bomb(bomb_map_position)
    bomb_map_position[:bomb] = true
    bomb_map_position[:power] = 2
  end

  def self.remove_explosion(bomb_position)
    element = get_map_element(bomb_position)
    add_explosion(bomb_position, nil)
    element[:power] = 0
  end

  def self.add_explosion(bomb_position, player_idx)
    element = get_map_element(bomb_position)
    element[:explosion] = player_idx
    element[:bomb] = false
    element[:type] = GameConstants::EMPTY_PLACE
    expand_explosion(bomb_position, element[:power], player_idx)
  end

  def self.expand_explosion(bomb_position, bomb_power, idx)
    y = bomb_position[:y]
    power = bomb_power

    # EXPAND UP
    while power.positive?
      break unless expand_explosion_loop_iteration({y: y - 1, x: bomb_position[:x]}, idx)

      power -= 1
      y -= 1
    end

    y = bomb_position[:y]
    power = bomb_power

    # EXPAND DOWN
    while power.positive?
      break unless expand_explosion_loop_iteration({y: y + 1, x: bomb_position[:x]}, idx)

      power -= 1
      y += 1
    end

    x = bomb_position[:x]
    power = bomb_power

    #EXPAND LEFT
    while power.positive?
      break unless expand_explosion_loop_iteration({y: bomb_position[:y], x: x - 1}, idx)

      power -= 1
      x -= 1
    end

    x = bomb_position[:x]
    power = bomb_power

    # EXPAND RIGHT
    while power.positive?
      break unless expand_explosion_loop_iteration({y: bomb_position[:y], x: x + 1}, idx)

      power -= 1
      x += 1
    end
  end

  private

  def self.expand_explosion_loop_iteration(position, idx)
    return false if position[:y] > GameConstants::MAP_SIZE - 1 || position[:x] > GameConstants::MAP_SIZE - 1 || position[:y] < 0 || position[:x] < 0

    curr_element = get_map_element(position)
    return false if curr_element[:type] == GameConstants::HARD_WALL

    curr_element[:type] = GameConstants::EMPTY_PLACE if curr_element[:type] == GameConstants::BOX_PLACE

    curr_element[:explosion] = idx
    true
  end

  # --------------- Explosion Logic END ------------------------

  # --------------- Map Helper Logic ----------------------------

  def self.get_new_position(player, destination)
    prev = player[:position]
    { x: prev[:x] + destination[:x], y: prev[:y] - destination[:y] }
  end

  # --------------- Map Helper Logic END -----------------------

  def self.game_loop
    @@game[:lobby].each_with_index do |player, idx|
      unless player[:dead]
        curr_position = get_map_element(player[:position])
        remove_player(player, curr_position, idx) if curr_position[:explosion]

      end
    end
    return ServerChannel.game_ended if game_ended?

    ServerChannel.game_update(@@game[:map])
    sleep(0.3)
    game_loop
  end

  def self.start_game
    @@game[:started] = true
    Thread.new do
      game_loop
    end
  end

  def self.add_kill(index)
    @@game[:killed] += 1
    player = @@game[:lobby][index]
    player[:kills] += 1
  end

  def self.update_win(player)
    player[:won] += 1
  end

  def self.game_ended?
    return false unless @@game[:killed] >= 3 || !ActionCable.server.connections.length

    if @@game[:killed] == 3
      player = @@game[:lobby].find { |player| !player[:dead] }
      update_win(player)
      PlayerHelper.update_db_user(player)
    end

    end_game
    true
  end

  def self.end_game
    # ActionCable.server.remote_connections.disconnect
  end

  private

  def self.get_map_element(element)
    @@game[:map][element[:y]][element[:x]]
  end
end
