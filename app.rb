require 'sinatra'
require 'erb'
require 'json'
require 'pry'

enable :sessions

helpers do 
  def create_deck
    ['A', 2, 3, 4, 5, 6, 7, 8, 9 ,10, 'J', 'Q', 'K'].product(['S', 'C', 'D', 'H'])
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
  def calculate_total

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
  binding.pry
  erb :blackjack
end