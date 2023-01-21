require_relative "../modules/game_info"

# игральная карта
class Card
  include GameInfo

  attr_reader :suit, :value

  def initialize(suit, value)
    @suit, @value = suit, value
    @hidden = true
  end

  def hidden?
    hidden
  end

  def visibled?
    !hidden
  end

  def hide
    self.hidden = true
  end

  def make_visible
    self.hidden = false
  end

  def image
    return "🂠" if hidden?

    "#{value}#{suit}"
  end

  private

  attr_accessor :hidden
end
