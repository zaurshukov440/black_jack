# frozen_string_literal: true

class Deck
  CARDS = [*(2..10), 'J', 'Q', 'K', 'A'].freeze
  SUITS = ['♥', '♦', '♣', '♠'].freeze

  attr_reader :deck

  def initialize
    @deck = {}
    complete_deck
  end

  def complete_deck
    CARDS.each do |card|
      SUITS.each do |suit|
        @deck[card.to_s + suit] = if %w[J Q K].include?(card)
                                    10
                                  elsif card == 'A'
                                    11
                                  else
                                    card
                                  end
      end
    end
  end

  def starter_set(player)
    2.times do |_i|
      card_arr = card
      player.cards_in_hands[card_arr.first] = card_arr.last
    end
  end

  def card
    card = @deck.keys.sample
    points = @deck.values_at(card).join.to_i
    @deck.delete(card)
    [card, points]
  end

  def new_deck
    @deck.clear
    complete_deck
  end
end
