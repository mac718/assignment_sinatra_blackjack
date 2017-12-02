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

get '/bet' do 
  erb :bet
end

post '/bet' do
  #@player = Player.new('Mike', @deck.deck, session[:bankroll])
  session[:bet] = params[:bet].to_i
  redirect to('blackjack')
end

get '/blackjack' do
  @deck = Deck.new
  @bet = session[:bet]
  @player = Player.new('Mike', @deck.deck, session[:bankroll] ||= 1000)
  binding.pry
  @bankroll = @player.bankroll - @bet
  session[:bankroll] = @bankroll
  @dealer = Dealer.new(@deck.deck)
  session[:deck] = @deck
  session[:player_hand] = @player.hand
  session[:dealer_hand] = @dealer.hand
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
  @player = Player.new('Mike', @deck.deck, session[:bankroll])
  @dealer = Dealer.new(@deck.deck)
  @player_hand = session[:player_hand]
  @dealer_hand = session[:dealer_hand]
  @dealer.play_dealer_hand(@dealer_hand, @deck.deck)
  if blackjack?(@player_hand)
    if blackjack?(@dealer_hand)
      @player.bankroll += session[:bet]
    else
      @player.bankroll += (session[:bet] + (session[:bet] * (3/2)))
    end
  end
  @computer_total = calculate_total(@dealer_hand)
  @player_total = calculate_total(@player_hand)
  if @player_total > @computer_total || @computer_total > 21
    @player.bankroll += session[:bet] * 2
    session[:bankroll] = @player.bankroll
  elsif @player_total == @computer_total
    @player.bankroll += session[:bet]
    session[:bankroll] = @player.bankroll
  else
    session[:bankroll] = @player.bankroll
  end
      
  @results_message = generate_results_message
  erb :"blackjack/show_results"
end