class SelectCardInput < BaseInput
  include ConsoleHelper

  def run
    prints_cards_to_select
    super
  end

  def transform(answer)
    terminate if exit?(answer)
    answer.to_i - 1
  end

  def validate
    @error = I18n.t('error.wrong_number') if cards.each_index.none?(@value)
  end

  def card
    @value && cards[@value]
  end

  private

  def cards
    @params[:cards]
  end

  def prints_cards_to_select
    cards.each_with_index do |card, index|
      puts I18n.t('common.press_to_choose', number: card.number, type: card.type, index: index + 1)
    end
    puts I18n.t('common.press_exit')
  end
end
