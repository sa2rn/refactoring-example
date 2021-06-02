class VirtualCard < BaseCard
  BALANCE = 150.0
  WITHDRAW_TAX = 5
  PUT_TAX = 2
  SENDER_TAX = 20

  def initialize(balance = BALANCE)
    super
  end

  def withdraw_tax_percent
    WITHDRAW_TAX
  end

  def put_tax_fixed
    PUT_TAX
  end

  def sender_tax_fixed
    SENDER_TAX
  end
end
