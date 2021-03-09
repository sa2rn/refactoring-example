class Card
  attr_reader :number, :balance

  def initialize
    @number = 16.times.map { rand(10) }.join
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

  protected

  def withdraw_tax_percent
    raise NotImplementedError
  end

  def put_tax_percent
    raise NotImplementedError
  end

  def put_tax_fixed
    raise NotImplementedError
  end

  def sender_tax_percent
    raise NotImplementedError
  end

  def sender_tax_fixed
    raise NotImplementedError
  end

  private

  def withdraw_tax(amount)
    amount * withdraw_tax_percent / 100.0
  end

  def put_tax
    amount * put_tax_percent / 100.0 + put_tax_fixed
  end

  def sender_tax
    amount * sender_tax_percent / 100.0 + sender_tax_fixed
  end
end
