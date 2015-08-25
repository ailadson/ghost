require "./ai_player.rb"

class Player
  attr_reader :name
  attr_accessor :losses, :round_dictionary

  def self.get_players(num, ai = false)
    players = []
    num -= 1 if ai
    1.upto(num) do |idx|
      puts "Player #{idx}, what is your name?"
      name = gets.chomp
      players << Player.new(name)
    end
    players << AI_Player.new if ai
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
