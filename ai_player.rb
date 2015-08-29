require './game_node.rb'

class AI_Player

  attr_accessor :name, :round_dictionary, :losses

  ALPH = ("a".."z").to_a

  def initialize(number_of_players)
    @name = "Hal"
    @losses = 0
    @number_of_players = number_of_players
  end

  def guess(fragment)
    puts "The current word fragment is #{fragment}"
    puts "#{@name}'s turn"
    puts "What is the next letter?"
    sleep 0.5
    if fragment == ""
      l = guess_best_first_letter
    else
      l = guess_best_letter(fragment)
    end
    puts l
    sleep(1)
    l
  end

  def guess_best_first_letter
    bad_letters = []

    @round_dictionary.each do |word|
      bad_letters << word[0] if word.length == @number_of_players + 1
    end

    dict = @round_dictionary.reject { |w| bad_letters.include?(w[0]) }

    dict.sample[0]
  end

  def guess_best_letter(fragment)
    best_letter = nil
    best_score = 0
    possible_letters(fragment).each do |l|
      next_fragment = fragment + l
      root_node = GameNode.new(next_fragment, @round_dictionary, @number_of_players)
      score = calculate_score(best_score,
                              root_node.number_winning_nodes,
                              root_node.number_losing_nodes)

      if score > best_score || best_letter.nil?
        best_letter = l
        best_score = score
      end
    end
    best_letter
  end

  def calculate_score(best_score, numb_of_winners, numb_of_losers)
    return best_score - 1 if numb_of_winners == 0
    numb_of_winners - numb_of_losers
  end

  def possible_letters(fragment)
    len = fragment.length
    #eww, and repeats functionality in game_node. refactor
    @round_dictionary.select do |word|
      word.start_with?(fragment) && word != fragment
    end.map do |word| word[len..len]
    end.uniq
  end

  def alert_invalid_guess
    puts "#{@name}, you have given an invalid guess."
  end

end
