require_relative "classes/game"
require_relative "modules/helper_io"

extend HelperIO

player_name = input_value("Введите ваше имя: ")

Game.start(player_name)
