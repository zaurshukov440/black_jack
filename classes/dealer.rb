require_relative 'member_of_game'
require_relative '../modules/game_info'

# дилер
class Dealer < MemberOfGame
  def initialize(deck_source)
    super("Дилер", deck_source)
  end

  def step
    if score < GameInfo::SCORE_FOR_DEALER_RISK
      add_card
    else
      pass
    end

    sleep(GameInfo::MESSAGE_PAUSE_IN_SECONDS)
  end
end
