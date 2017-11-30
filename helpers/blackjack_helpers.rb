module BlackjackHelpers
  def create_deck
    ['Ace', 2, 3, 4, 5, 6, 7, 8, 9 ,10, 'Jack', 'Queen', 'King'].product(['S', 'C', 'D', 'H'])
  end

  def deal_hand
    session[:deck] = create_deck.shuffle
    hand = []
    2.times do 
      hand << session[:deck].pop
    end
    hand
  end

  def hit
    session[:deck].pop
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

  def play_computer_hand
    while calculate_total(session[:computer_hand]) < 17
      session[:computer_hand] << hit
    end
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