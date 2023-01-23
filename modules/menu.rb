# frozen_string_literal: true

module Menu
  def menu
    {
      0 => {
        command: :pass,
        text: 'Пропустить'
      },

      1 => {
        command: :add_card,
        text: 'Добавить карту'
      },

      2 => {
        command: :open_cards,
        text: 'Открыть карты'
      }
    }
  end

  def print_menu_steps
    puts 'Сделайте ход'
    menu.each do |key, value|
      puts "#{key} - #{value[:text]}"
    end
  end
end
