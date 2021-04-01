class CardType < ValidableEntity
  attr_reader :type

  def initialize(type)
    @type = type.to_sym
  end

  private

  def validate
    errors << I18n.t('error.wrong_card_type') unless BaseCard::CARD_TYPES.key?(type)
  end
end
