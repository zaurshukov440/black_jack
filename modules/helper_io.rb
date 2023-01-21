require_relative "../classes/game"
require_relative "../classes/member_of_game"
require_relative "game_info"

# Вспомогательные методы для ввода/вывода информации
module HelperIO
  private

  def input_value(text)
    puts text
    print "> "

    value = ""
    while value.empty? do
      value = gets.chomp
    end

    value
  end

  def select_value(value_variants, text = nil)
    puts text unless text.nil? || text.empty?

    value = ""
    while !value_variants.include?(value) do
      print "> "
      value = gets.chomp
      puts
    end

    value
  end

  def divider
    "-" * 20
  end

  def visualize_info
    system "clear"
    visualize_bank
    visualize_member_of_game(Game.dealer)
    visualize_member_of_game(Game.player)
    puts divider
    puts
  end

  def visualize_bank
    puts divider
    puts "Банк: #{Game.bank.cash}$"
    puts divider
    puts
  end

  def visualize_member_of_game(member)
    puts "#{member.name}"
    puts "На счету: #{member.cash}$"

    card_images = member.cards.empty? ? [] : member.cards.map(&:image)

    if member.cards_visibled?
      puts "Карты: #{card_images.join(" ")} - #{member.score} очков"
    else
      puts "Карты: #{card_images.join(" ")} - ✕ очков"
    end

    puts "\n"
  end

  def print_round_end_text(round_end_key)
    messages = {
      player_win: "Вы выиграли этот раунд. Сумма ваших очков ближе к #{GameInfo::WIN_SCORE}",
      player_loss: "Дилер выиграл этот раунд. Вы превысили #{GameInfo::WIN_SCORE} очков",
      draw: "Ничья. Вы с дилером набрали одинаковое количество очков",
      dealer_win: "Дилер выиграл этот раунд. Сумма его очков ближе к #{GameInfo::WIN_SCORE}",
      dealer_loss: "Вы выиграли этот раунд. Дилер превысил #{GameInfo::WIN_SCORE}"
    }

    puts messages[round_end_key]
  end

  def print_hello_message(player_name)
    system "clear"
    puts "Добро пожаловать в игру Black Jack, #{player_name}!"
    sleep(GameInfo::MESSAGE_PAUSE_IN_SECONDS)
  end

  def print_bye_message(reason)
    system "clear"
    puts "Игра окончена"
    bye_messages = {
      player_no_cash: "У вас закончились деньги, чтобы сделать ставку",
      dealer_no_cash: "У дилера закончились деньги, чтобы сделать ставку",
      player_stop_game: "Вы решили остановить игру"
    }

    puts bye_messages[reason]
    puts

    print_results_of_game
    puts "До скорых встреч, #{Game.player.name}!"
  end

  def print_results_of_game
    puts "Ваш игровой счёт по итогу игры составил #{Game.player.cash} $"
    delta_cash = Game.player.cash - GameInfo::INITIAL_CASH

    return puts "Поздравляем, вы заработали #{delta_cash} $" if delta_cash.positive?

    return puts "Увы, но вы проиграли #{delta_cash} $" if delta_cash.negative?

    puts "Что было в карманах, то и осталось. Зато мы прекрасно провели время за игрой"
  end
end
