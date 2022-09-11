module Helpers::StatisticsHelper

  def update_kill(id)
    user = User.find(id)
    unless user.update(kills: user.kills + 1)
      puts "There was problem with updating KILLS for user with id: #{id}"
    end
  end

  def update_suicide(id)
    user = User.find(id)
    unless user.update(suicides: user.suicides + 1)
      puts "There was problem with updating SUICIDES for user with id: #{id}"
    end
  end

  def update_win(id)
    user = User.find(id)
    unless user.update(wins: user.wins + 1)
      puts "There was problem with updating WINS for user with id: #{id}"
    end
  end

  def update_games(id)
    user = User.find(id)
    unless user.update(games_played: user.games_played + 1)
      puts "There was problem with updating GAMES_PLAYED for user with id: #{id}"
    end
  end

end
