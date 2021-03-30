class BaseConsole
  include ConsoleHelper

  def no_cards?
    puts I18n.t('error.no_active_cards') if current_account.card.empty?
    current_account.card.empty?
  end
end
