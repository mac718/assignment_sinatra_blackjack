require "./helpers/blackjack_helpers.rb"

class Player 
  include BlackjackHelpers
  attr_accessor :hand, :bankroll
  
  def initialize(name, deck, bankroll = 1000)
    @bankroll = bankroll
    @name = name
    @hand = deal_hand(deck)
  end

  def hit(deck)
    deck.pop
  end
end

class Dealer < Player
  def initialize(deck)
    @name = "Dealer"
    @hand = deal_hand(deck)
  end

  def play_dealer_hand(dealer_hand, deck)
    while calculate_total(dealer_hand) < 17
      dealer_hand << hit(deck)
    end
  end
end