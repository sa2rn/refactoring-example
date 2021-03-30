class CardTypeInput < BaseInput
  def transform(answer)
    answer.to_sym
  end

  def validate
    @error = I18n.t('error.wrong_card_type') unless BaseCard::CARD_TYPES.key?[@value]
  end
end
