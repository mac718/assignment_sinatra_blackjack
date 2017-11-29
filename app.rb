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
    hand.reduce{ |total, card| total + card[1] }
  end
end

get '/' do 
  erb :home
end

get '/blackjack'do
  session[:player_hand] = deal_hand
  session[:computer_hand] = deal_hand
  binding.pry
  erb :blackjack
end

post '/blackjack/hit' do 
  session[:player_hand] << hit
  erb :blackjack
end