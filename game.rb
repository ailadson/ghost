require "./player.rb"

class Game

  def self.play_game
    puts "How many people will be playing?"
    number_of_players = gets.chomp.to_i
    puts "Do you want to play with an AI? (Y/n)"
    have_ai = gets.chomp

    until have_ai == "Y" || have_ai == "n"
      puts "Great, but you didn't answer the question"
      puts "Do you want to play with an AI? (Y/n)"
      have_ai = gets.chomp
    end

    ai = (have_ai == "Y") ? true : false

    players = Player.get_players(number_of_players, ai)
    game = Game.new(players)
    game.run
  end

  attr_reader :dictionary

  LOSER_WORD = "GH"

  def initialize(players)
    @players = players
    @dictionary = []
    @fragment = String.new
    populate_dictionary
    @current_player = @players.first
    @players.each{ |p| p.round_dictionary = @dictionary }
    @players.each{ |pl| p pl.name }
  end

  def populate_dictionary
    File.open("ghost-dictionary.txt").read.each_line do |line|
      @dictionary << line.chomp
    end
  end

  def run
    until @players.length == 1
      play_round
    end
    puts "#{@players.first.name} is the winner!"
  end

  def play_round
    puts "---------------"
    puts "New Round"
    puts "---------------"
    @current_player = @players.first
    until @current_player.losses == LOSER_WORD.length
      play_turns
    end
    puts "#{@current_player.name} losses."
    puts ""
    @players.delete(@current_player)
  end

  def play_turns
    @round_dictionary = @dictionary
    @fragment = ""
    lost = false
    until lost
      next_player!
      lost = take_turn(@current_player)
    end

  end

  def next_player!
    idx = (@players.index(@current_player) + 1) % (@players.length)
    @current_player = @players[idx]
  end

  def take_turn(player)
    guess = @current_player.guess(@fragment)

    until valid_play?(@fragment + guess)
      @current_player.alert_invalid_guess
        guess = @current_player.guess(@fragment)
    end

    @fragment += guess

    prune_dictionary()

    @players.each{ |p| p.round_dictionary = @round_dictionary }

    if lost?
      @current_player.losses += 1
      puts "#{@current_player.name} has lost the round!"
      puts "You now have #{@current_player.losses} letters -- #{LOSER_WORD[0..(@current_player.losses-1)]}"
      puts "----------"
      return true
    else
      puts ""
      return false
    end


  end

  def lost?
    @round_dictionary.any?{ |word| word == @fragment}
  end

  def inspect
  end

  def valid_play?(str)
    @round_dictionary.any? do |word|
      word.start_with?(str)
    end
  end

  def prune_dictionary()
    @round_dictionary = @round_dictionary.select { |word| word.start_with?(@fragment) }
  end

end

Game.play_game
