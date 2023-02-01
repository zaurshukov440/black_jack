# frozen_string_literal: true

require_relative './controllers/game_controller'
require_relative './models/dealer'
require_relative './models/gamer'
require_relative './models/deck'

def start
  @controller = GameController.new
  @controller.name
end

start

def gameplay
  @controller.start
  @controller.show_cards
  @controller.to_bet
  @controller.show_bank
  @controller.show_moves
  @controller.gamer_choice
  @controller.scoring
  @controller.game_score
  @controller.match_score
end

def game_over?
  if @controller.game_over?
    if @controller.new_match?
      start
      return
    else
      abort
    end
  end
  abort unless @controller.new_game?
end

loop do
  gameplay
  game_over?
end
