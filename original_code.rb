require 'pry'

class Card
  attr_reader :point_value, :phrase
  def initialize(phrase, points)
    @phrase = phrase
    @point_value = points
  end

  def to_s
    "#{phrase}: #{point_value}pts"
  end
end

class Deck
  SINGLE_POINT_PHRASES = [ "Referencing the cold open while cold opening",
                           "Moon Cult",
                           "Little Mix",
                           "Riley brings up depressing political news",
                           "Brooklin 99 reference",
                           "Riley has become a house wife",
                           "Austrailia has weird names for things",
                           "Anna Coryn Segway of the Week",
                           "What's next on the list of topics in front of us?",
                           "Fiona wakes up too dang early in the morning"]

  TWO_POINT_PHRASES = [ "Any reference to Liam",
                        "Disagreement about who says the intro/outro",
                        "A new Nintendo game/direct/anouncement came out and Riley is excited",
                        "Podcast is too long to get to advice questions",
                        "Fiona talks about hate watching content",
                        "Riley admonishes Fiona for referencing the list",
                        "Eurovision",
                        "Avatar the Last Airbender",
                        "Fiona's old housemate Maddie"]

  THREE_POINT_PHRASES = [ "Everyone in Riley's office is ____. (Haha, she works from home, get it?)",
                          "Eggidence",
                          "Fiona thinks everyone knows some obscure reference",
                          "Fiona tunes out while Riley talks about politics, anime, or Nintendo",
                          "Fiona is concerned everything will be boring to listen to"]

  attr_accessor :deck

  def initialize
    @deck = []

    create_cards(SINGLE_POINT_PHRASES, 1)
    create_cards(TWO_POINT_PHRASES, 2)
    create_cards(THREE_POINT_PHRASES, 3)

    deck.shuffle!
  end

  def create_cards(phrase_arr, points)
    phrase_arr.each do |phrase|
      deck << Card.new(phrase, points)
    end
  end

  def deal_to(players_hand, position)
    players_hand[position] = deck.pop
  end
end

class Player
  attr_accessor :hand, :score
  attr_reader :name

  def initialize(name)
    @hand = { '1' => nil,
              '2' => nil,
              '3' => nil,
              '4' => nil,
              '5' => nil,
              '6' => nil,
              '7' => nil }
    @name = name
    @score = 0
  end

  def redeam_card(key)
    begin
      @score += hand[key].point_value
    rescue NoMethodError
    end
  end

  def hand_is_empty?
    hand.values.all? { |card| card == nil}
  end
end

class CommandLineGame
  attr_accessor :player1, :player2, :deck
  def initialize
    @player1 = Player.new('One')
    @player2 = Player.new('Two')
    @deck = Deck.new
    @user_ended_game = nil

    deal_full_new_hand(player1.hand)
    deal_full_new_hand(player2.hand)
  end

  def play
    display_welcome_message
    loop do
      display_scores
      display_hands
      user_takes_turn #prompt user for move. case statement when (end of game string) change user_ended_game? to true actually prob a guard clause for that. then split string into parts and eval
      break if user_ended_game? || (player1.hand_is_empty? && player2.hand_is_empty?)# user enters a particular string or both hands are empty. write deal so hands are only empty here if deck is empty.
    end
    display_results
    display_goodbye_message
  end

  def deal_full_new_hand(hand)
    hand.keys.each do |key|
      deck.deal_to(hand, key)
    end
  end

  def display_welcome_message
    puts "*Cold open references the cold open*"
    puts "This is the Gal Pals Podcast Cardgame." # write better intro
  end

  def display_hand(player)
    puts "#{player.name}'s Cards:"
    player.hand.each do |key, card|
      puts "#{key} : #{card}"
    end
  end

  def display_scores
    puts "Current scores: #{player1.name}: #{player1.score}, #{player2.name}: #{player2.score}"
  end

  def display_hands
    display_hand(player1)
    display_divider
    display_hand(player2)
  end

  def display_divider
    puts ""
    puts "-------"
    puts ""
  end

  def user_takes_turn
    commands = nil
    loop do
      puts "enter a command" # placeholder prompt
      commands = gets.chomp.downcase.split(' ')
      break if ((commands[0] == '1' || commands[0] == '2') && player1.hand.keys.include?(commands[1])) || commands[0] == 'stop'
      puts "invalid input, try again."
    end

    case commands[0]
    when '1'
      player1.redeam_card(commands[1])
      deck.deal_to(player1.hand, commands[1])
    when '2'
      player2.redeam_card(commands[1])
      deck.deal_to(player2.hand, commands[1])
    when 'stop'
      @user_ended_game = true
    end
  end

  def user_ended_game?
    !!@user_ended_game
  end

  def display_results
    puts "Final Scores:"
    puts "#{player1.name}: #{player1.score}"
    puts "#{player2.name}: #{player2.score}"

    if player1.score > player2.score
      puts "#{player1.name} wins!"
    elsif  player1.score < player2.score
      puts "#{player2.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def display_goodbye_message
    puts "Goodbye."
  end
end

class BrowserGame
  attr_accessor :player1, :player2, :deck
  def initialize
    @player1 = Player.new('One')
    @player2 = Player.new('Two')
    @deck = Deck.new
    @user_ended_game = nil

    deal_full_new_hand(player1.hand)
    deal_full_new_hand(player2.hand)
  end

  def play
    display_welcome_message
    loop do
      display_scores
      display_hands
      user_takes_turn #prompt user for move. case statement when (end of game string) change user_ended_game? to true actually prob a guard clause for that. then split string into parts and eval
      break if user_ended_game? || (player1.hand_is_empty? && player2.hand_is_empty?)# user enters a particular string or both hands are empty. write deal so hands are only empty here if deck is empty.
    end
    display_results
    display_goodbye_message
  end

  def deal_full_new_hand(hand)
    hand.keys.each do |key|
      deck.deal_to(hand, key)
    end
  end

  def display_welcome_message
    puts "*Cold open references the cold open*"
    puts "This is the Gal Pals Podcast Cardgame." # write better intro
  end

  def display_hand(player)
    puts "#{player.name}'s Cards:"
    player.hand.each do |key, card|
      puts "#{key} : #{card}"
    end
  end

  def display_scores
    puts "Current scores: #{player1.name}: #{player1.score}, #{player2.name}: #{player2.score}"
  end

  def display_hands
    display_hand(player1)
    display_hand(player2)
  end


  def user_takes_turn
    commands = nil
    loop do
      puts "enter a command" # placeholder prompt
      commands = gets.chomp.downcase.split(' ')
      break if ((commands[0] == '1' || commands[0] == '2') && player1.hand.keys.include?(commands[1])) || commands[0] == 'stop'
      puts "invalid input, try again."
    end

    case commands[0]
    when '1'
      player1.redeam_card(commands[1])
      deck.deal_to(player1.hand, commands[1])
    when '2'
      player2.redeam_card(commands[1])
      deck.deal_to(player2.hand, commands[1])
    when 'stop'
      @user_ended_game = true
    end
  end

  def user_ended_game?
    !!@user_ended_game
  end

  def display_results
    puts "Final Scores:"
    puts "#{player1.name}: #{player1.score}"
    puts "#{player2.name}: #{player2.score}"

    if player1.score > player2.score
      puts "#{player1.name} wins!"
    elsif  player1.score < player2.score
      puts "#{player2.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def display_goodbye_message
    puts "Goodbye."
  end
end

game = BrowserGame.new
game.play