require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'pry'
require "./helpers/blackjack_helpers.rb"

enable :sessions

helpers BlackjackHelpers

get '/' do 
  erb :home
end

get '/blackjack' do
  session[:player_hand] = deal_hand
  session[:computer_hand] = deal_hand
  binding.pry
  erb :blackjack
end

post '/blackjack/hit' do 
  session[:player_hand] << hit
  @player_total = calculate_total(session[:player_hand])
  if @player_total > 21
    session[:player_hand].pop
    redirect to('/blackjack/stay')
  else
    erb :blackjack
  end
end

get '/blackjack/stay' do 
  play_computer_hand
  @computer_total = calculate_total(session[:computer_hand])
  @player_total = calculate_total(session[:player_hand])
  @results_message = generate_results_message
  erb :"blackjack/show_results"
end