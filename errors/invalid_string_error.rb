# frozen_string_literal: true

module Codebreaker
  class InvalidStringError < ValidationError
    def initialize(msg = I18n.t('errors.invalid_string'))
      super
    end
  end
end
