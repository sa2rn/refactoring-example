# frozen_string_literal: true

module Codebreaker
  class InvalidEnumError < ValidationError
    def initialize(msg = I18n.t('errors.invalid_enum'))
      super
    end
  end
end
