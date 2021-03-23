# frozen_string_literal: true

module Codebreaker
  class InvalidStringLengthError < ValidationError
    def initialize(msg = I18n.t('errors.invalid_string_length'))
      super
    end
  end
end
