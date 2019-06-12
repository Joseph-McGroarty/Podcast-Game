require 'sinatra'
require "sinatra/reloader" if development?
require "tilt/erubis"

get '/' do
  erb :home
end

get '/play' do
  erb :play
end

get '/rules' do
  erb :rules
end

get '/endgame' do
  erb :endgame
end