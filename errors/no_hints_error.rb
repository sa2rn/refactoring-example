# frozen_string_literal: true

module Codebreaker
  class NoHintsError < StandardError
    def initialize(msg = I18n.t('errors.no_hints'))
      super
    end
  end
end
