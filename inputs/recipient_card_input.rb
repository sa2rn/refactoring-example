class RecipientCardInput < BaseInput
  def defaults
    { label: I18n.t('ask.recipient_card') }
  end

  def manager
    @params[:manager]
  end

  def card
    manager.find_card_by_number(@value)
  end

  def validate
    if @value.length != Card::NUMBER_LENGTH
      @error = I18n.t('error.no_card_with_number', number: recipient_card_number)
    elsif !manager.card_with_number_exists?(@value)
      @error = I18n.t('error.wrong_card_number')
    end
  end
end
