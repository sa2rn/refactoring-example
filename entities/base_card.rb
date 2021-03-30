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
    charge(-amount - withdraw_tax(amount))
    WithdrawMoneyResult.new(self, amount)
  end

  def put_money(amount)
    charge(amount - put_tax(amount))
    PutMoneyResult.new(self, amount)
  end

  def send_money(amount, recipient_card)
    charge(-amount - sender_tax(amount))
    recipient_card.charge(amount - put_tax(amount))
    SendMoneyResult.new(self, recipient_card, amount)
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

  protected

  def charge(amount)
    @balance += amount
  end
end
