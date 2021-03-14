class VirtualCard < Card
  def initialize(balance = 150.00)
    super
  end

  def type
    'virtual'
  end

  def withdraw_tax_percent
    88
  end

  def put_tax_fixed
    1
  end

  def sender_tax_fixed
    1
  end
end
