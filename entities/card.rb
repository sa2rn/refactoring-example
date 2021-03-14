class Card
  attr_reader :balance

  def initialize(balance)
    @balance = balance
    @number = 16.times.map { rand(10) }.join
  end

  def number
    @number ||= 16.times.map { rand(10) }.join
  end

  def withdraw_money(amount)
    @balance -= amount - withdraw_tax(amount)
  end

  def put_money(amount)
    @balance += amount - put_tax(amount)
  end

  def send_money(recipient, amount)
    @balance -= amount - sender_tax(amount)
    recipient.put_money(amount)
  end

  def type
    raise NotImplementedError
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
end
