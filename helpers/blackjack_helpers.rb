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

  def blackjack?(hand)
    hand.size == 2 && calculate_total(hand) == 21
  end

  def process_blackjack_hand(player_hand, dealer_hand, bet, bankroll)
    if blackjack?(player_hand)
      if blackjack?(dealer_hand)
        bankroll += session[:bet]
      else
        bankroll += (session[:bet] + (session[:bet] * (3/2)))
      end
    end
  end

  def process_non_blackjack_hand(player_total, dealer_total, bet, bankroll)
    if player_total > dealer_total || dealer_total > 21
      

      bankroll += (bet * 2)
      binding.pry
      session[:bankroll] = bankroll

    elsif player_total == dealer_total
      
      bankroll += bet
      binding.pry

      session[:bankroll] = bankroll
    else
      binding.pry

      session[:bankroll] = bankroll

    end
  end

  def process_hand(player_hand, player_total, dealer_hand, dealer_total, bet, bankroll)
    if blackjack?(player_hand)
      process_blackjack_hand(player_hand, dealer_hand, bet, bankroll)
    else
      process_non_blackjack_hand(player_total, dealer_total, bet, bankroll)
    end
  end

  def generate_results_message(dealer_total, player_total)
    if dealer_total > 21
      "Dealer busts! You win!"
    elsif player_total > dealer_total
      "Congrats! You win!"
    elsif dealer_total > player_total
      "Dealer wins! Bummer!"
    else
      "It's a tie!"
    end
  end
end