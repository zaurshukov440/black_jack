require_relative "member_of_game"
require_relative "../modules/game_info"

# игровой банк для хранения ставок
class Bank
  include GameInfo

  attr_reader :cash, :bet

  def initialize
    @cash = 0
  end

  def get_a_bet(player, dealer, bet = MINIMUM_RATE)
    self.bet = bet
    player.cash_down(bet)
    dealer.cash_down(bet)
    self.cash = bet * 2
  end

  def pay_cache(winner)
    winner.cash_up(cash)
    self.cash = 0
  end

  def return_a_bet(player, dealer)
    player.cash_up(bet)
    dealer.cash_up(bet)
    self.cash = 0
  end

  private

  attr_writer :cash, :bet
end
