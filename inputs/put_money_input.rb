class PutMoneyInput < NumberInput
  def defaults
    { label: I18n.t('common.input_amount') }
  end

  def validate
    if !@value.positive?
      @error = I18n.t('error.correct_amount')
    elsif tax >= @value
      @error = I18n.t('error.tax_higher')
    end
  end

  def tax
    @params[:card].put_tax(@value)
  end
end
