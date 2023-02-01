# frozen_string_literal: true

module Validation
  def self.included(base)
    base.include(InstanceMethods)
  end

  module InstanceMethods
    def valid_name?(name)
      raise 'Имя не может быть меньше двух символов!' if name.length < 2
    end

    def valid_input?(input)
      raise 'Неверно выбран номер!' unless [1, 2, 3].include?(input)
    end
  end
end
