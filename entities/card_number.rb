class CardNumber < ValidableEntity
  def initialize(manager, card_number)
    @manager = manager
    @card_number = card_number
  end

  def card
    @manager.find_card_by_number(@card_number)
  end

  private

  def validate
    if @card_number.length != BaseCard::NUMBER_LENGTH
      errors << I18n.t('error.no_card_with_number', number: @card_number)
    elsif !@manager.card_with_number_exists?(@card_number)
      errors << I18n.t('error.wrong_card_number')
    end
  end
end
