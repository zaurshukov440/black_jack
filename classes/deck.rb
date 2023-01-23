# frozen_string_literal: true

require_relative 'card'
require_relative '../modules/game_info'

# колода карт
class Deck
  attr_reader :cards

  def initialize
    @cards = []

    GameInfo::SUITS.each do |suit|
      GameInfo::VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end
  end

  # перетасовать колоду
  def snuffle
    cards.shuffle!
  end

  def pop
    cards.pop
  end

  def push(card)
    cards << card
  end

  # def show
  #   cards.each do |card|
  #     puts card.image
  #   end
  # end

  private

  attr_writer :cards
end
