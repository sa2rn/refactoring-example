class PutTransationResult < BaseTransactionResult
  def message
    I18n.t('success.put_money', amount: @amount, number: @card.number,
                                balance: @card.balance, tax: @card.put_tax(@amount))
  end
end
