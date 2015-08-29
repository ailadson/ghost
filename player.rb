require "./ai_player.rb"

class Player
  attr_reader :name
  attr_accessor :losses, :round_dictionary

  def self.get_players(number_of_players, ai = false)
    players = []
    number_of_players -= 1 if ai
    1.upto(number_of_players) do |idx|
      puts "Player #{idx}, what is your name?"
      name = gets.chomp
      players << Player.new(name)
    end
    players << AI_Player.new(number_of_players + 1) if ai
  end

  def initialize(name)
    @losses = 0
    @name = name
  end

  def guess(fragment)
    puts "The current word fragment is #{fragment}"
    puts "#{@name}'s turn"
    puts "What is the next letter?"
    letter = gets.chomp
  end

  def alert_invalid_guess
    puts "#{@name}, you have given an invalid guess."
  end


end
