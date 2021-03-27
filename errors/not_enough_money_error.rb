class NotEnoughMoneyError < StandardError
  def initialize(msg = I18n.t('errors.not_enough_money'))
    super
  end
end
