class Card
  NUMBER_LENGTH = 16
  NUMBER_RAND = 10
  CARD_TYPES = %w[usual capitalist virtual].freeze

  attr_reader :type, :balance

  def self.create(type, *args)
    raise ArgumentError unless CARD_TYPES.any?(type)

    const_get("#{type.capitalize}Card").new(type, *args)
  end

  def initialize(type, balance = 0)
    raise ArgumentError unless CARD_TYPES.any?(type)

    @type = type
    @balance = balance
  end

  def number
    @number ||= Array.new(NUMBER_LENGTH) { rand(NUMBER_RAND) }.join
  end

  def withdraw_money(amount)
    new_balance = balance - withdraw_tax(amount)
    return NotEnoughMoneyError if new_balance.negative?

    @balance = new_balance
    withdraw_money_result(amount)
  end

  def put_money(amount)
    new_balance = balance + amount - put_tax(amount)
    raise NotEnoughMoneyError if new_balance.negative?

    @balance = new_balance
    put_money_result(amount)
  end

  def send_money(amount, recipient_card)
    new_balance = balance - amount - sender_tax(amount)
    raise NotEnoughMoneyError if new_balance.negative?

    recipient_card.receive_money(amount)
    @balance = new_balance
    send_money_result(amount, recipient_card)
  end

  def withdraw_tax_percent
    0
  end

  def put_tax_percent
    0
  end

  def put_tax_fixed
    0
  end

  def sender_tax_percent
    0
  end

  def sender_tax_fixed
    0
  end

  protected

  def withdraw_money_result(amount)
    I18n.t('successful_withdraw_money', amount: amount, balance: balance, tax: withdraw_tax(amount))
  end

  def put_money_result(amount)
    I18n.t('successful_put_money', amount: amount, balance: balance, tax: put_tax(amount))
  end

  def send_money_result(amount, recipient_card)
    result = I18n.t('successful_send_money', amount: amount, balance: balance, tax: sender_tax(amount))
    result << I18n.t('successful_receive_money', amount: amount, balance: recipient_card.balance, tax: recipient_card.put_tax(amount))
  end

  def receive_money(amount)
    new_balance = balance + amount - put_tax(amount)
    raise NotEnoughMoneyError if new_balance.negative?

    @balance = new_balance
  end

  def withdraw_tax(amount)
    amount * withdraw_tax_percent / 100.0
  end

  def put_tax(amount)
    amount * put_tax_percent / 100.0 + put_tax_fixed
  end

  def sender_tax(amount)
    amount * sender_tax_percent / 100.0 + sender_tax_fixed
  end
end
