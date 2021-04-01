class CardSelect < ValidableEntity
  attr_reader :card_index

  def initialize(account, card_index)
    @cards = account.card
    @card_index = card_index.to_i - 1
    @valid_range = 0...@cards.length
  end

  def validate
    errors << I18n.t('error.wrong_number') unless @valid_range.cover?(card_index)
  end

  def card
    @cards[card_index]
  end
end
