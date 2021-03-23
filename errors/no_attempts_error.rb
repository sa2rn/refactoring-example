# frozen_string_literal: true

module Codebreaker
  class NoAttemptsError < StandardError
    def initialize(msg = I18n.t('errors.no_attempts'))
      super
    end
  end
end
