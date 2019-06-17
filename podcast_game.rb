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
  def deal_full_hand(player)
    # get array of player's hand keys, deal a card to each position key
    player.hand.keys.each do |position|
      session[:deck].deal_to(player.hand, position)
    end
  end

  deal_full_hand(session[:player1])
  deal_full_hand(session[:player2])

  # redirect to get '/play'
  redirect "/play"
end

# turn in a card, increment player score, deal new card, redirect to play
post '/redeemcard/:player/:number' do 
  # parse any necessary to know what player redeemed which card
  redeeming_player = nil

  if params[:player] == '1'
    redeeming_player = session[:player1]
  elsif params[:player] == '2'
    redeeming_player = session[:player2]
  end

  redeemed_card = redeeming_player.hand[params[:number]]

  # increment that player's score by the point value of the card

  redeeming_player.score += redeemed_card.point_value

  # deal player a new card in redeemed slot
  session[:deck].deal_to(redeeming_player.hand, params[:number])

  # redirect to get '/play'
  redirect "/play"
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
  @player1 = session[:player1]
  @player2 = session[:player2]
  @result_message = nil

  #determine winner and update @result_message accordingly
  if @player1.score > @player2.score
    @result_message = "#{@player1.name} wins!"
  elsif @player1.score < @player2.score
    @result_message = "#{@player2.name} wins!"
  elsif @player1.score == @player2.score
    @result_message = "It's a tie!"
  end

  erb :endgame
end