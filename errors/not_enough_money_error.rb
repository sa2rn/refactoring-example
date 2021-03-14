class NotEnoughMoneyError < StandardError
  def initialize(msg = I18n.t('not_enough_money'))
end
