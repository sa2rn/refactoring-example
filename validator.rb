# frozen_string_literal: true

module Codebreaker
  module Validator
    def check_number(*args, range:, message: nil)
      raise InvalidNumberError, *[message].compact unless args.all? { |number| range.cover?(number) }
    end

    def check_string_length(*args, range:, message: nil)
      raise InvalidStringLengthError, *[message].compact unless args.all? { |str| range.cover?(str.size) }
    end

    def check_string(*args, regex:, message: nil)
      raise InvalidStringError, *[message].compact unless args.all? { |str| str.match(regex) }
    end

    def check_enum(*args, enum:, message: nil)
      raise InvalidEnumError, *[message].compact unless args.all? { |value| enum.include?(value) }
    end
  end
end
