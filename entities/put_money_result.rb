class PutMoneyResult
  def initialize(card, amount)
    @card = card
    @amount = amount
  end

  def message
    I18n.t('success.put_money', amount: @amount, number: @card.number,
                                balance: @card.balance, tax: @card.put_tax(@amount))
  end
end
