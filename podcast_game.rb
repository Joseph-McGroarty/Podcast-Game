require 'sinatra'
require "sinatra/reloader" if development?
require "tilt/erubis"
require_relative 'custom_classes'

# view home page
get '/' do
  erb :home
end

# delete any past game data and set up a new game
post '/newgame' do
  #
end

# turn in a card, increment player score, deal new card, redirect to play
post '/redeemcard/:number' do # double check :number syntax is right
  # possibly make it '/redeemcard/:player/:number'
end

# show the current game state with links for user to make plays
get '/play' do
  @player1 = Player.new("One")
  erb :play
end

# display the rules page
get '/rules' do
  erb :rules
end

# determine winner, show results
get '/endgame' do
  erb :endgame
end