class WithdrawMoneyInput < NumberInput
  def defaults
    { label: I18n.t('common.withdraw_amount') }
  end

  def validate
    if @value.positive?
      @error = I18n.t('error.correct_amount')
    elsif money_left <= 0
      @error = I18n.t('error.tax_higher')
    end
  end

  def card
    @params[:card]
  end

  def money_left
    card.balance - card.put_tax(@value)
  end
end
