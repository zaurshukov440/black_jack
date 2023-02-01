# frozen_string_literal: true

require_relative '../modules/validation'
class GameController
  include Validation

  attr_reader :user_name

  MOVES = { 1 => 'Пропустить ход',
            2 => 'Взять карту',
            3 => 'Открыть карты' }.freeze

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new('Дилер')
  end

  def name
    puts 'Перед началом игры введите ваше имя:'
    @gamer = Gamer.new(gets.strip.chomp)
    puts "#{@gamer.name}, добро пожаловать!"
  end

  def start
    @deck.starter_set(@gamer)
    @deck.starter_set(@dealer)
    puts 'Раздача карт...'
    loading
    system('clear')
    puts 'Игра началась!'
  end

  def show_cards
    puts "\nВаши карты:"
    @gamer.cards_in_hands.each_key do |card|
      print "|#{card}| "
    end
    puts
    puts "\nВаши очки: #{@gamer.points}"
    puts "\nКарты дилера:"
    puts '|*| ' * @dealer.cards_in_hands.size
  end

  def to_bet
    puts "\nВаша ставка 10 долларов."
    @gamer.cash_account -= 10
    puts 'Ставка дилера 10 долларов.'
    @dealer.cash_account -= 10
  end

  def show_bank
    puts "\nНа вашем счете #{@gamer.cash_account} долларов."
    puts "На счете дилера #{@dealer.cash_account} долларов."
  end

  def show_moves
    puts "\nВаш ход! Введите номер действия, котрое хотите сделать:"
    MOVES.each do |move_number, move|
      puts "#{move_number} -> #{move}"
    end
  end

  def gamer_choice
    move_number = gets.to_i
    valid_input?(move_number)
    case move_number
    when 1
      system('clear')
      gamer_pass
    when 2
      system('clear')
      gamer_take_card
    when 3
      system('clear')
      open_cards
    end
  end

  def dealer_choice
    score_sum = @dealer.cards_in_hands.values.sum
    if score_sum >= 17
      dealer_pass
    elsif score_sum < 17
      dealer_take_card
    end
    open_cards
  end

  def scoring
    puts "\nПодсчёт очков..."
    loading
    return if bust?

    if @gamer.points < @dealer.points
      puts 'Вы проиграли!'
      @dealer.wins += 1
      @dealer.cash_account += 20
    elsif @gamer.points > @dealer.points
      puts 'Вы выиграли!'
      @gamer.wins += 1
      @gamer.cash_account += 20
    else
      puts 'Ничья!'
      @dealer.cash_account += 10
      @gamer.cash_account += 10
    end
  end

  def game_score
    puts "\nКоличество очков по результатам партии:"
    puts "#{@gamer.name} - #{@gamer.points}"
    puts "#{@dealer.name} - #{@dealer.points}"
  end

  def match_score
    puts "\nСчёт по партиям:"
    puts "#{@gamer.name} - #{@gamer.wins}"
    puts "#{@dealer.name} - #{@dealer.wins}"
  end

  def new_game?
    puts "\nЧтобы начать новую партию, нажмите Enter"
    puts "\nЧтобы выйти, введите любой символ и нажмите Enter"
    gamer_input = gets.chomp
    if gamer_input == ''
      @gamer.fold_cards
      @dealer.fold_cards
      @deck.new_deck
      system('clear')
      true
    else
      false
    end
  end

  def new_match?
    puts "\nЧтобы начать новую игру, нажмите Enter"
    puts "\nЧтобы выйти, введите любой символ и нажмите Enter"
    gamer_input = gets.chomp
    system('clear')
    gamer_input == ''
  end

  def game_over?
    if @gamer.cash_account.zero?
      puts 'Вы проиграли игру!'
      show_bank
      match_score
      true
    elsif @dealer.cash_account.zero?
      puts 'Вы выиграли игру!'
      show_bank
      match_score
      true
    else
      false
    end
  end

  private

  def loading
    (['/', '—', '\\', '|'] * 4).each do |item|
      print "#{item}\r"
      sleep 0.2
    end
  end

  def gamer_pass
    @gamer.to_pass
    puts "\nВы пасуете!"
    dealer_choice
  end

  def gamer_take_card
    @gamer.take_card(@deck)
    new_card = @gamer.cards_in_hands.keys.last
    puts "\nНовая карта: |#{new_card}|."
    dealer_choice
  end

  def open_cards
    puts "\nВы открываете карты!"
    puts "\nВаши карты:"
    puts @gamer.open_cards
    puts "\nКарты дилера:"
    puts @dealer.open_cards
  end

  def dealer_pass
    @dealer.to_pass
    puts "\nДилер пасует!"
  end

  def dealer_take_card
    @dealer.take_card(@deck)
    puts "\nДилер берет карту!"
  end

  def bust?
    if @gamer.bust? && !@dealer.bust?
      puts 'Вы проиграли! Перебор.'
      @dealer.wins += 1
      @dealer.cash_account += 20
      true
    elsif !@gamer.bust? && @dealer.bust?
      puts 'Вы выиграли! У дилера перебор.'
      @gamer.wins += 1
      @gamer.cash_account += 20
      true
    elsif @gamer.bust? && @dealer.bust?
      puts 'Ничья! У обоих игроков перебор.'
      @dealer.cash_account += 10
      @gamer.cash_account += 10
      true
    else
      false
    end
  end
end
