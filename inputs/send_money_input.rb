class SendMoneyInput < NumberInput
  def defaults
    { label: I18n.t('common.input_amount') }
  end

  def validate
    if !@value.positive?
      @error = I18n.t('error.correct_amount')
    elsif sender_balance.negative?
      @error = I18n.t('error.not_enough_money')
    elsif recipient_tax >= @value
      @error = I18n.t('error.not_enough_money_sender_card')
    end
  end

  def card
    @params[:card]
  end

  def recipient_card
    @params[:card]
  end

  def sender_balance
    card.balance - amount - card.send_tax(@value)
  end

  def recipient_tax
    recipient_card.put_tax(@value)
  end
end
