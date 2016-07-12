require 'set'
require 'byebug'

class Game
  MAX_LOSS_COUNT = 5

  attr_accessor :current_player, :previous_player, :fragment, :dictionary, :losses

  def initialize(player_1, player_2, dictionary)
    @current_player = player_1
    @previous_player = player_2
    @dictionary = dictionary
    @fragment = ""
    @losses = {
      player_1.name => 0,
      player_2.name => 0
    }
  end

  def run
    until losses.values.any? { |val| val >= MAX_LOSS_COUNT}
      display_standings
      play_round
      self.fragment = ""
    end
    if losses[current_player.name] >= MAX_LOSS_COUNT
      puts "#{previous_player.name} wins the whole thing!"
    else
      puts "#{current_player.name} wins the whole thing!"
    end
  end

  def play_round
    while !game_over
      take_turn(current_player)
      next_player!
    end
    puts "#{previous_player.name} loses"
    losses[previous_player.name] += 1
  end

  def next_player!
    @current_player, @previous_player = @previous_player, @current_player
  end

  def take_turn(player)
    player_guess = ""
    valid = false
    while valid == false
      player_guess = player.guess
      if !valid_play?(player_guess)
        player.alert_invalid_guess
      else
        valid = true
      end
    end
    self.fragment = "#{fragment}#{player_guess}"
  end

  def valid_play?(string)
      check_string = fragment + string
      dictionary.each do |word|
        return true if word.include?(check_string) && string.length == 1
      end
      false
  end

  def game_over
    if dictionary.include?(fragment) && fragment.length > 2
      return true
    end
    false
  end

  def record(player)
    "GHOST"[0...losses[player.name]]
  end

  def display_standings
    puts "#{current_player.name} has #{record(current_player)}"
    puts "#{previous_player.name} has #{record(previous_player)}"
  end

end

class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess
    gets.chomp.downcase
  end

  def alert_invalid_guess
    puts "That is an invalid guess!"
  end

end

if __FILE__ == $PROGRAM_NAME
  player_1 = Player.new("Davin")
  player_2 = Player.new("Whocares")

  my_dictionary = File.readlines("dictionary.txt").map(&:chomp).to_set

  my_ghost = Game.new(player_1, player_2, my_dictionary)
  my_ghost.run
end
