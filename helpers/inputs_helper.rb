module InputsHelper
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

  def withdraw_amount_input
    output('common.withdraw_amount')
    input.to_i
  end

  def put_amount_input
    output('common.input_amount')
    input.to_i
  end

  def send_amount_input
    output('common.send_amount')
    input.to_i
  end

  def account_form_data
    { name: name_input, age: age_input, login: login_input, password: password_input }
  end

  def fill_account_form(manager)
    loop do
      form = AccountForm.new(manager, account_form_data)
      if form.valid?
        yield form
        break
      end
      puts form.errors
    end
  end

  def card_type_input
    loop do
      output('create_card')
      answer = input
      return if exit?(answer)

      card_type = CardType.new(answer)
      if card_type.valid?
        yield card_type.type
        return
      end
      output('error.wrong_card_type')
    end
  end

  def card_input(account)
    any_cards?(account) do
      prints_cards_to_choose(account)
      loop do
        answer = input
        return if exit?(answer)

        card_select = CardSelect.new(account, answer)
        if card_select.valid?
          yield card_select.card, card_select.card_index
          return
        end
        puts card_select.errors
      end
    end
  end

  def destroy_card_input(*args, &block)
    output('common.if_you_want_to_delete')
    card_input(*args, &block)
  end

  def withdraw_card_input(*args, &block)
    output('common.choose_card_withdrawing')
    card_input(*args, &block)
  end

  def put_card_input(*args, &block)
    output('common.choose_card')
    card_input(*args, &block)
  end

  def send_card_input(*args, &block)
    output('common.choose_card_sending')
    card_input(*args, &block)
  end

  def prints_cards_to_choose(account)
    account.card.each_with_index do |card, index|
      output('common.press_to_choose', number: card.number, type: card.type, index: index + 1)
    end
    output('common.press_exit')
  end

  def recipient_card_number_input
    output('common.recipient_card')
    card_number = CardNumber.new(manager, input)
    card_number.valid? ? yield(card_number.card) : puts(card_number.errors)
  end

  def any_cards?(account)
    account.card.any? ? yield : output('error.no_active_cards')
  end
end
