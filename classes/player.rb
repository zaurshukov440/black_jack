require_relative 'member_of_game'
require_relative '../modules/helper_io'
require_relative '../modules/menu'
require_relative '../modules/game_info'

# игрок
class Player < MemberOfGame
  include HelperIO
  include Menu

  def step
    print_menu_steps

    step_value = select_value(["0", "1", "2"]).to_i
    send(menu[step_value][:command])

    sleep(MESSAGE_PAUSE_IN_SECONDS)

    menu[step_value][:command]
  end

  private

  def open_cards
    puts "Открываем карты!"
  end
end
