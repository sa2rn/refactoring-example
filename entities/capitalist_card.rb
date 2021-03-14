class CapitalistCard < Card
  def initialize(balance = 100.00)
    super
  end

  def type
    'capitalist'
  end

  def withdraw_tax_percent
    4
  end

  def put_tax_fixed
    10
  end

  def sender_tax_percent
    10
  end
end
