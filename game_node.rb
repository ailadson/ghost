class GameNode

  def initialize(fragment, dictionary, number_of_players, parent=nil, depth=0)
    @fragment = fragment
    @dictionary = dictionary
    @parent = parent
    @children = []
    @depth = depth
    @number_of_players = number_of_players
    construct_children
  end

  def number_losing_nodes
    @children.count do |child|
      if child.losing_node?
        true
      end
    end
  end

  def number_winning_nodes
    @children.count do |child|
      if child.winning_node?
        true
      end
    end
  end

  def inspect
    "Fragment of #{@fragment}/Depth of #{@depth}"
  end

  def losing_node?
    if @dictionary.include?(@fragment)
      return true if my_turn?
      return false
    end

    if my_turn?
      @children.all?{ |child| child.losing_node? }
    else
      @children.any?{ |child| child.winning_node? }
    end
  end

  def winning_node?
    if @dictionary.include?(@fragment)
      return false if my_turn?
      return true
    end

    if my_turn?
      @children.any?{ |child| child.winning_node? }
    else
      @children.all?{ |child| child.losing_node? }
    end
  end

  def my_turn?
    (@number_of_players % @depth == 0) ? true : false
  end

  def construct_children
    next_fragments.each do |fragment|
      child_node = GameNode.new(fragment, @dictionary, @number_of_players, self, @depth+1)
      @children << child_node
    end

  end

  def next_fragments
    next_frags = []
    fragment_dictionary.each{ |word| next_frags << @fragment + word[@fragment.length] }
    next_frags.uniq
  end

  def fragment_dictionary
    @dictionary.select{ |word| word.start_with?(@fragment) && word != @fragment }
  end
end
