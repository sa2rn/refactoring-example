class MoneyConsole < BaseConsole
  extend Forwardable

  def_delegators :@root, :manager, :current_account

  def initialize(root)
    @root = root
  end

  def withdraw_money
    return unless withdraw_card_input.run && put_money_input.run

    result = manager.withdraw_money(current_account, withdraw_card_input.value, put_money_input.value)
    puts result.message
  end

  def put_money
    return unless put_card_input.run && put_money_input.run

    result = manager.put_money(current_account, put_card_input.value, put_money_input.value)
    puts result.message
  end

  def send_money
    return unless send_card_input.run && recipient_card_input.run && send_money_input.run

    result = manager.send_money(*send_money_args)
    puts result.message
  end

  private

  def send_money_args
    [current_account, send_card_input.value, recipient_card_input.value, send_money_input.value]
  end

  def withdraw_card_input
    @withdraw_card_input ||= SelectCardInput.new(
      cards: current_account.card,
      label: I18n.t('common.choose_card_withdrawing')
    )
  end

  def cards
    current_account.card
  end

  def put_card_input
    @put_card_input ||= SelectCardInput.new(cards: cards, label: I18n.t('common.choose_card'))
  end

  def send_card_input
    @send_card_input ||= SelectCardInput.new(cards: cards, label: I18n.t('common.choose_card_sending'))
  end

  def recipient_card_input
    @recipient_card_input ||= RecipientCardInput.new(manager: manager)
  end

  def withdraw_money_input
    @withdraw_money_input ||= WithdrawMoneyInput.new(card: withdraw_card_input.value)
  end

  def put_money_input
    @put_money_input ||= PutMoneyInput.new(card: put_card_input.card)
  end

  def send_money_input
    @send_money_input ||= SendMoneyInput.new(card: send_card_input.card)
  end
end
