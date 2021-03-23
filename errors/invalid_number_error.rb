# frozen_string_literal: true

module Codebreaker
  class InvalidNumberError < ValidationError
    def initialize(msg = I18n.t('errors.invalid_number'))
      super
    end
  end
end
