class Deck
  attr_reader :deck
  def initialize
    @deck = create_deck.shuffle
  end

  def create_deck
    ['Ace', 2, 3, 4, 5, 6, 7, 8, 9 ,10, 'Jack', 'Queen', 'King'].product(['S', 'C', 'D', 'H'])
  end
end