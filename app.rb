require 'sinatra'
require 'erb'
require 'json'
require 'pry'

get '/' do 
  erb :home
end