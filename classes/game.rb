# frozen_string_literal: true

require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'bank'
require_relative '../modules/helper_io'
require_relative '../modules/game_info'

# игровая механика
class Game
  extend HelperIO

  class << self
    include GameInfo

    attr_reader :player, :dealer, :deck, :bank, :current_gamer

    # инициализация и старт игры
    def initialize(player_name)
      print_hello_message(player_name)

      @deck = Deck.new
      @bank = Bank.new
      @player = Player.new(player_name, @deck)
      @dealer = Dealer.new(@deck)

      continue_game = true
      while continue_game
        new_round

        continue_game, reason = continue_game?
      end

      print_bye_message(reason)
    end

    private

    attr_writer :player, :dealer, :deck, :bank, :current_gamer

    def new_round
      deck.snuffle

      2.times { player.take_card }
      2.times { dealer.take_card }

      visualize_info
      puts 'Делаем ставки, господа!'
      sleep(MESSAGE_PAUSE_IN_SECONDS)

      bank.get_a_bet(player, dealer)

      visualize_info

      self.current_gamer = player

      winner = nil
      round_end = false

      until round_end
        step = current_gamer.step

        round_end = gamers_has_maximum_of_cards? ||
                    step == :open_cards ||
                    player.score > WIN_SCORE

        visualize_info

        toggle_current_gamer
      end

      winner, round_end_key = open_cards_and_get_winner

      winner.nil? ? bank.return_a_bet(player, dealer) : bank.pay_cache(winner)

      visualize_info
      print_round_end_text(round_end_key)

      player.return_cards
      dealer.return_cards
    end

    def gamers_has_maximum_of_cards?
      player.cards.length >= NUMBER_OF_CARDS_TO_OPEN && dealer.cards.length >= NUMBER_OF_CARDS_TO_OPEN
    end

    def open_cards_and_get_winner
      dealer.cards.each(&:make_visible)

      return [dealer, :player_loss] if player.score > WIN_SCORE

      return [player, :player_win] if player.score > dealer.score && player.score <= WIN_SCORE

      return [dealer, :dealer_win] if dealer.score > player.score && dealer.score <= WIN_SCORE

      return [nil, :draw] if dealer.score == player.score

      [player, :dealer_loss]
    end

    def can_player_get_a_bet?
      player.cash >= MINIMUM_RATE
    end

    def can_dealer_get_a_bet?
      dealer.cash >= MINIMUM_RATE
    end

    def toggle_current_gamer
      self.current_gamer = current_gamer == player ? dealer : player
    end

    def continue_game?
      return [false, :player_no_cash] unless can_player_get_a_bet?

      return [false, :dealer_no_cash] unless can_dealer_get_a_bet?

      continue_game = input_value('Продолжить игру? Если согласны введите Y').downcase

      return [false, :player_stop_game] unless continue_game == 'y'

      [true, nil]
    end
  end
end
