class BaseTransaction < ValidableEntity
  def initialize(card, amount)
    @card = card
    @amount = amount
  end

  def run
    raise NotImplementedError
  end
end
