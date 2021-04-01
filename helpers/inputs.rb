module Inputs
  def login_input
    output('ask.login')
    input
  end

  def password_input
    output('ask.password')
    input
  end

  def name_input
    output('ask.name')
    input
  end

  def age_input
    output('ask.age')
    input.to_i
  end

  def account_form_data
    {
      name: name_input,
      age: age_input,
      login: login_input,
      password: password_input
    }
  end

  def select_card_input(account)
    prints_cards_to_select(account)
    loop do
      card_index = input
      return if exit?(card_index)

      card_select = CardSelect.new(account, card_index)
      if card_select.valid?
        yield card_select.card, card_select.card_index
        return
      end
      puts card_select.errors
    end
  end

  def prints_cards_to_select(account)
    account.card.each_with_index do |card, index|
      output('common.press_to_choose', number: card.number, type: card.type, index: index + 1)
    end
    output('common.press_exit')
  end

  def card_number_input
    card_number = CardNumber.new(manager, input)
    if card_number.valid?
      yield card_number.card
      return
    end
    puts card_number.errors
  end
end
