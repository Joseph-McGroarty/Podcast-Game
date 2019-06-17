require 'sinatra'
require "sinatra/reloader" if development?
require "tilt/erubis"
require_relative 'custom_classes'

# enable and set up sessions to persist state
configure do
  enable :sessions
  set :session_secret, 'secret'
end

# view home page
get '/' do
  erb :home
end

# delete any past game data and set up a new game
post '/newgame' do
  # create (or reassign) objects game needs
  session[:player1] = Player.new("One")
  session[:player2] = Player.new("Two")
  session[:deck] = Deck.new

  # deal cards to give each player full hand
  # redirect to get '/play'
  redirect "/play"
end

# turn in a card, increment player score, deal new card, redirect to play
post '/redeemcard/:number' do # double check :number syntax is right
  # possibly make it '/redeemcard/:player/:number'
  # parse any input necessary to know what player redeemed a card
  # increment that player's score by the point value of the card
  # remove redeemed card from player's hand
  # unless deck is empty, deal player a new card in the now empty slot
  # redirect to get '/play'
end

# show the current game state with links for user to make plays
get '/play' do
  @player1 = session[:player1]
  @player2 = session[:player2]
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