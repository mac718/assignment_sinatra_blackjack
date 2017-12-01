require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'pry'
require "./helpers/blackjack_helpers.rb"
require_relative 'deck'
require_relative 'player'

enable :sessions

helpers BlackjackHelpers

get '/' do 
  erb :home
end

get '/blackjack' do
  @deck = Deck.new
  @player = Player.new('Mike', @deck.deck)
  @dealer = Dealer.new(@deck.deck)
  session[:deck] = @deck
  session[:player_hand] = @player.hand
  session[:dealer_hand] = @dealer.hand
  binding.pry
  erb :blackjack
end

post '/blackjack/hit' do 
  @deck = session[:deck]
  @player = Player.new('Mike', @deck.deck)
  @player_hand = session[:player_hand]
  @player_hand << @player.hit(@deck.deck)
  @player_total = calculate_total(@player_hand)
  if @player_total > 21
    @player_hand.pop
    redirect to('/blackjack/stay')
  else
    erb :blackjack
  end
end

get '/blackjack/stay' do 
  @deck = session[:deck]
  @player = Player.new('Mike', @deck.deck)
  @dealer = Dealer.new(@deck.deck)
  @player_hand = session[:player_hand]
  @dealer_hand = session[:dealer_hand]
  @dealer.play_dealer_hand(@dealer_hand, @deck.deck)
  @computer_total = calculate_total(@dealer_hand)
  @player_total = calculate_total(@player_hand)
  @results_message = generate_results_message
  erb :"blackjack/show_results"
end