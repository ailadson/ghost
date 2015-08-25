class AI_Player

  attr_accessor :name, :round_dictionary, :losses

  ALPH = ("a".."z").to_a

  def initialize
    @name = "Hal"
    @losses = 0
  end

  def guess(fragment)
    puts "The current word fragment is #{fragment}"
    puts "#{@name}'s turn"
    puts "What is the next letter?"
    sleep(2)
    word = guess_word(fragment)
    w = word[fragment.length]
    puts w
    sleep(1)
    w
  end

  def guess_word(fragment)
    guesses = @round_dictionary.select do |word|
      word.length > fragment.length
    end
    return guesses.sort.first unless guesses.empty?
    @round_dictionary.sample
  end

  def alert_invalid_guess
    puts "#{@name}, you have given an invalid guess."
  end

end
