class UsualCard < Card
  def initialize(type, balance = 50.00)
    super
  end

  def withdraw_tax_percent
    5
  end

  def put_tax_percent
    2
  end

  def sender_tax_fixed
    20
  end
end
