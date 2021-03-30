class CardConsole < BaseConsole
  extend Forwardable

  def_delegators :@root, :manager, :current_account

  def initialize(root)
    @root = root
  end

  def create_card
    loop do
      if card_type_input.run
        manager.create_card(current_account, card_type_input.value)
        break
      end
    end
  end

  def destroy_card
    return if no_cards?

    loop do
      next unless select_card_input.run

      manager.destroy_card(current_account, select_card_input.value) if confirm_delete?
      break
    end
  end

  def show_cards
    return if no_cards?

    current_account.card.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  private

  def card_type_input
    @card_type_input ||= CardTypeInput.new
  end

  def select_card_input
    @select_card_input ||= SelectCardInput.new(
      label: I18n.t('common.if_you_want_to_delete'),
      cards: current_account.card
    )
  end

  def current_card
    current_account.card[select_card_input.value]
  end

  def confirm_delete?
    confirm?(I18n.t('common.destroy_card', number: current_card.number))
  end
end
