class BaseCard
  NUMBER_LENGTH = 16
  NUMBER_RAND = 10
  CARD_TYPES = {
    usual: 'UsualCard',
    capitalist: 'CapitalistCard',
    virtual: 'VirtualCard'
  }.freeze

  attr_reader :balance

  def self.create(type, *args)
    const_get(CARD_TYPES[type]).new(*args)
  end

  def initialize(balance = 0)
    @balance = balance
  end

  def type
    CARD_TYPES.invert[self.class.to_s]
  end

  def number
    @number ||= Array.new(NUMBER_LENGTH) { rand(NUMBER_RAND) }.join
  end

  def withdraw_money(amount)
    WithdrawTransation.new(self, amount).run
  end

  def put_money(amount)
    PutTransaction.new(self, amount).run
  end

  def send_money(amount, recipient_card)
    SendTransaction.new(self, recipient_card, amount).run
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

  def withdraw_tax(amount)
    amount * withdraw_tax_percent / 100.0
  end

  def put_tax(amount)
    amount * put_tax_percent / 100.0 + put_tax_fixed
  end

  def sender_tax(amount)
    amount * sender_tax_percent / 100.0 + sender_tax_fixed
  end

  def update_balance(balance)
    @balance = balance
  end
end
