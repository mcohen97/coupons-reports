class PromotionNotFoundError < StandardError
  def initialize(msg = 'Cannot generate report, promotion does not exist')
    super
  end
end
