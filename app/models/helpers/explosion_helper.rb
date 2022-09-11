class ExplosionHelper

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

  def self.add_bomb(bomb_map_position)
    bomb_map_position[:bomb] = true
    bomb_map_position[:power] = 2
  end

end
