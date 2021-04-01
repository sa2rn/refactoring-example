class SendTransactionResult < BaseTransactionResult
  def initialize(params)
    @recipient_card = params[:recipient_card]
    super(params)
  end

  def message
    [send_message, receive_message].join("\n")
  end

  private

  def send_message
    I18n.t('success.send_money', amount: @amount, number: @card.number,
                                 balance: @card.balance, tax: @card.sender_tax(@amount))
  end

  def receive_message
    I18n.t('success.put_money', amount: @amount, number: @recipient_card.number,
                                balance: @recipient_card.balance, tax: @recipient_card.put_tax(@amount))
  end
end
