require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'pry'

enable :sessions

helpers do 
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
      binding.pry
      if card.class == Fixnum 
        total += card 
      elsif card == 'Ace'
        total < 21 ? total += 1 : total += 11
      else 
        total += 10 
      end
    end
    total
  end
end

get '/' do 
  erb :home
end

get '/blackjack'do
  session[:player_hand] = deal_hand
  session[:computer_hand] = deal_hand
  
  erb :blackjack
end

post '/blackjack/hit' do 
  session[:player_hand] << hit
  
  @player_total = calculate_total(session[:player_hand])
  redirect to('/blackjack/stay') if @player_total > 21
  erb :blackjack
end