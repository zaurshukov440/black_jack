# frozen_string_literal: true

require_relative 'deck'
require_relative 'bank'
require_relative '../modules/game_info'
require_relative '../modules/menu'

# участник игры (класс-родитель для игрока и дилера)
class MemberOfGame
  include GameInfo
  include Menu

  attr_reader :name, :cards, :cash

  def initialize(name, deck_source)
    @name = name
    @cash = INITIAL_CASH
    @cards = []
    @deck_source = deck_source
  end

  def take_card
    card = @deck_source.pop
    card.make_visible if instance_of?(Player)
    cards << card
  end

  def cards
    while cards.length.positive?
      card = cards.pop
      card.hide
      @deck_source.push(card)
    end
  end

  def cash_up(summ)
    self.cash += summ
  end

  def cash_down(summ)
    self.cash -= summ
  end

  def score
    score_value = 0
    cards.each do |card|
      score_value += if NUMERIC_CARDS.include?(card.value)
                       card.value.to_i
                     elsif PICTURE_CARDS.include?(card.value)
                       10
                     elsif card.value == 'A'
                       score_for_ace_card(score_value)
                     end || 0
    end
    score_value
  end

  def cards_visibled?
    cards.all?(&:visibled?)
  end

  private

  def score_for_ace_card(current_score)
    max_score_with_ace = current_score + MAX_VALUE_FOR_ACE

    return MAX_VALUE_FOR_ACE if max_score_with_ace <= WIN_SCORE

    MIN_VALUE_FOR_ACE
  end

  def pass
    puts instance_of?(Dealer) ? 'Дилер пропускает ход' : 'Вы пропускаете ход'
  end

  def add_card
    puts instance_of?(Dealer) ? 'Дилер берёт карту' : 'Вы берёте карту'
    take_card
  end

  attr_writer :name, :cards, :cash
end
