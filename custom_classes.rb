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