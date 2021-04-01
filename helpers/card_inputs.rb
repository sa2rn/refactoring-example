module CardInputs
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

  def card_type_input
    loop do
      output('create_card')
      card_type = CardType.new(handle_exit(input))
      if card_type.valid?
        yield card_type.type
        return
      end
      output('error.wrong_card_type')
    end
  end

  def card_input(account)
    prints_cards_to_choose(account)
    loop do
      card_select = CardSelect.new(account, handle_exit(input))
      if card_select.valid?
        yield card_select.card
        return
      end
      puts card_select.errors
    end
  end

  def card_input_with_any_cards(account, &block)
    any_cards?(account) { card_input(account, &block) }
  end

  def handle_exit(answer)
    leave_loop if exit?(answer)
    answer
  end

  def destroy_card_input(*args, &block)
    output('common.if_you_want_to_delete')
    card_input_with_any_cards(*args, &block)
  end

  def withdraw_card_input(*args, &block)
    output('common.choose_card_withdrawing')
    card_input_with_any_cards(*args, &block)
  end

  def put_card_input(*args, &block)
    output('common.choose_card')
    card_input_with_any_cards(*args, &block)
  end

  def send_card_input(*args, &block)
    output('common.choose_card_sending')
    card_input_with_any_cards(*args, &block)
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
