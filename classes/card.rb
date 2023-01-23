# frozen_string_literal: true

require_relative '../modules/game_info'

# игральная карта
class Card
  include GameInfo

  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
    @hidden = true
  end

  def hidden?
    hidden
  end

  def visibled?
    !hidden
  end

  def hide
    @hidden = true
  end

  def make_visible
    @hidden = false
  end

  def image
    return '🂠' if hidden?

    "#{value}#{suit}"
  end
end
