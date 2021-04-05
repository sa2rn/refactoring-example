class CapitalistCard < BaseCard
  BALANCE = 100.0
  WITHDRAW_TAX = 4
  PUT_TAX = 10
  SENDER_TAX = 10

  def initialize(balance = BALANCE)
    super
  end

  def withdraw_tax_percent
    WITHDRAW_TAX
  end

  def put_tax_fixed
    PUT_TAX
  end

  def sender_tax_percent
    SENDER_TAX
  end
end
