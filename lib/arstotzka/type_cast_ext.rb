# frozen_string_literal: true

module Arstotzka
  # @api public
  #
  # Extension of Arstotzka::TypeCast
  #
  # @see https://www.rubydoc.info/gems/arstotzka/Arstotzka/TypeCast Arstotzka::Typecast
  module TypeCast
    # Converts value to period
    #
    # @param value [String] string to be converted
    #
    # @return [Integer] parsed period
    #
    # @example
    #   module Arstotzka
    #     module TypeCast
    #       class Dummy
    #         extend TypeCast
    #       end
    #     end
    #   end
    #
    #   Arstotzka::TypeCast::Dummy.to_period('2days')
    #   # returns  2.days (2 * 24 * 3600 seconds)
    def to_period(value)
      Mercy::PeriodParser.parse(value)
    end

    # Converts value to float
    #
    # Accepts +"inf"+ and +"-inf"+ return +/- +Float::INFINITY+
    #
    # @param value [String] string to be converted
    #
    # @return [Float] Converted float
    #
    # @example
    #   module Arstotzka
    #     module TypeCast
    #       class Dummy
    #         extend TypeCast
    #       end
    #     end
    #   end
    #
    #   Arstotzka::TypeCast::Dummy.to_infinity_float('-0.75')
    #   # returns -0.75
    #
    #   Arstotzka::TypeCast::Dummy.to_infinity_float('inf')
    #   # returns Float::INFINITY
    #
    #   Arstotzka::TypeCast::Dummy.to_infinity_float('-inf')
    #   # returns -Float::INFINITY
    def to_infinity_float(value)
      return value if value.is_a?(Numeric)
      return -Float::INFINITY if value =~ /-inf/
      return Float::INFINITY if value =~ /inf/

      value.to_f
    end
  end
end
