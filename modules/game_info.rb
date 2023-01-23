# frozen_string_literal: true

module GameInfo
  SUITS = %w[♡ ♤ ♧ ♢].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  NUMERIC_CARDS = %w[2 3 4 5 6 7 8 9 10].freeze
  PICTURE_CARDS = %w[J Q K].freeze
  MINIMUM_RATE = 10
  INITIAL_CASH = 100
  WIN_SCORE = 21
  MIN_VALUE_FOR_ACE = 1
  MAX_VALUE_FOR_ACE = 11
  NUMBER_OF_CARDS_TO_OPEN = 3
  SCORE_FOR_DEALER_RISK = 17
  MESSAGE_PAUSE_IN_SECONDS = 1
end
