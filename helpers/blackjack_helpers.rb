module BlackjackHelpers
 
  def deal_hand(deck)
    hand = []
    2.times do 
      hand << deck.pop
    end
    hand
  end

  def calculate_total(hand)
    total = 0
    card_values = hand.map { |card| card[0] }
    card_values.each do |card|
      if card.class == Fixnum 
        total += card 
      elsif card == 'Ace'
        total += 11
      else 
        total += 10 
      end
    end
    card_values.select { |value| value == 'Ace' }.count.times do
      total -= 10 if total > 21
    end
    total
  end

  def generate_results_message
    if @computer_total > 21
      "Dealer busts! You win!"
    elsif @player_total > @computer_total
      "Congrats! You win!"
    elsif @computer_total > @player_total
      "Dealer wins! Bummer!"
    else
      "It's a tie!"
    end
  end
end