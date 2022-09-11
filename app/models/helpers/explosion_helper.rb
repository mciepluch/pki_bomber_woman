module Helpers::ExplosionHelper

  def bomb_setup(destination, player_idx)
    player = @game[:lobby][player_idx]
    bomb_pos = get_new_position(player, destination)
    return unless validate_player_move(bomb_pos)
    add_bomb(bomb_pos)

    sleep 4
    add_explosion(bomb_pos, player_idx)
    # add_explosion(element, '-', player_idx)

    sleep 2
    #Removal of explosions
    remove_explosion(bomb_pos)
  end

  def add_bomb(bomb_position)
    @game[:map] = DbClient.db_get_map
    element = get_map_element(bomb_position)
    element[:bomb] = true
    element[:power] = 2
    DbClient.db_set_map(@game[:map])
  end

  def remove_explosion(bomb_position)
    @game[:map] = DbClient.db_get_map
    element = get_map_element(bomb_position)
    add_explosion(bomb_position, nil)
    element[:power] = 0
    DbClient.db_set_map(@game[:map])
  end

  def add_explosion(bomb_position, player_idx)
    @game[:map] = DbClient.db_get_map
    element = get_map_element(bomb_position)
    element[:explosion] = player_idx
    element[:bomb] = false
    element[:type] = GameConstants::EMPTY_PLACE
    expand_explosion(bomb_position, element[:power], player_idx)

    DbClient.db_set_map(@game[:map])
  end

  def expand_explosion(bomb_position, bomb_power, idx)
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

  # def add_explosion(bomb_position, sign = '+', player_idx)
  #   @game[:map] = DbClient.db_get_map
  #   if sign == '+'
  #     element = get_map_element(bomb_position)
  #     element[:explosion] << (player_idx)
  #     element[:type] = GameConstants::EMPTY_PLACE
  #   else
  #     index = get_map_element(bomb_position)[:explosion].find_index(player_idx)
  #     get_map_element(bomb_position)[:explosion].insert(index, 1)
  #   end
  #
  #   DbClient.db_set_map(@game[:map])
  # end

  # def expand_explosion(bomb_position, sign = '+', idx)
  #   y = bomb_position[:y]
  #   power = bomb_position[:power]
  #
  #   # EXPAND UP
  #   while power.positive? && y >= 0
  #     break unless expand_explosion_loop_iteration({y: y, x: bomb_position[:x]}, sign, idx)
  #
  #     # curr_element = get_map_element({y: y, x: bomb[:x]})
  #     # break if curr_element[:type] == GameConstants::HARD_WALL
  #     #
  #     # curr_element[:type] = GameConstants::EMPTY_PLACE if curr_element[:type] == GameConstants::BOX_PLACE
  #     #
  #     # #TODO: REFACTOR WE CAN OMIT THIS IF, IF WE INCREASE Y!
  #     # if sign == '+'
  #     #   curr_element.explosion.push(idx)
  #     # else
  #     #   index = curr_element.explosion.find_index(idx)
  #     #   curr_element.explosion.insert(index, 1)
  #     # end
  #
  #     power -= 1
  #     y -= 1
  #   end
  #
  #   y = bomb_position[:y]
  #   power = bomb_position[:power]
  #
  #   # EXPAND DOWN
  #   while power.positive? && y <= GameConstants::MAP_SIZE - 1
  #     break unless expand_explosion_loop_iteration({y: y, x: bomb_position[:x]}, sign, idx)
  #
  #     power -= 1
  #     y += 1
  #   end
  #
  #   x = bomb_position[:x]
  #   power = bomb_position[:power]
  #
  #   #EXPAND LEFT
  #   while power.positive? && x >= 0
  #     break unless expand_explosion_loop_iteration({y: bomb_position[:y], x: x}, sign, idx)
  #
  #     power -= 1
  #     x -= 1
  #   end
  #
  #   x = bomb_position[:x]
  #   power = bomb_position[:power]
  #
  #   # EXPAND RIGHT
  #   while power.positive? && x <= GameConstants::MAP_SIZE - 1
  #     break unless expand_explosion_loop_iteration({y: bomb_position[:y], x: x}, sign, idx)
  #
  #     power -= 1
  #     x += 1
  #   end
  # end

  private

  def expand_explosion_loop_iteration(position, idx)
    return false if position[:y] > GameConstants::MAP_SIZE - 1 || position[:x] > GameConstants::MAP_SIZE - 1 || position[:y] < 0 || position[:x] < 0

    curr_element = get_map_element(position)
    return false if curr_element[:type] == GameConstants::HARD_WALL

    curr_element[:type] = GameConstants::EMPTY_PLACE if curr_element[:type] == GameConstants::BOX_PLACE

    curr_element[:explosion] = idx
    true
  end

  # def expand_explosion_loop_iteration(position, sign = '+', idx)
  #   curr_element = get_map_element(position)
  #   return false if curr_element[:type] == GameConstants::HARD_WALL
  #
  #   curr_element[:type] = GameConstants::EMPTY_PLACE if curr_element[:type] == GameConstants::BOX_PLACE
  #
  #   #TODO: REFACTOR WE CAN OMIT THIS IF, IF WE INCREASE Y!
  #   if sign == '+'
  #     curr_element.explosion.push(idx)
  #   else
  #     index = curr_element.explosion.find_index(idx)
  #     curr_element.explosion.insert(index, 1)
  #   end
  # end

end
