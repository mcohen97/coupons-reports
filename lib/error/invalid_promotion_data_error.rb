# frozen_string_literal: true

class InvalidPromotionDataError < StandardError
  def initialize(msg = 'The promotion data provided is invalid')
    super
  end
end