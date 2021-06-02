module CardConsole
  def create_card
    card_type_input { |card_type| manager.create_card(current_account, card_type) }
  end

  def destroy_card
    destroy_card_input(current_account) do |card|
      manager.destroy_card(current_account, card) if confirm?('common.destroy_card', number: card.number)
    end
  end

  def show_cards
    any_cards?(current_account) { current_account.cards.each { |card| puts "- #{card.number}, #{card.type}" } }
  end

  def withdraw_money
    withdraw_card_input(current_account) do |card|
      puts manager.withdraw_money(current_account, card, withdraw_amount_input)
    end
  end

  def put_money
    put_card_input(current_account) do |card|
      puts manager.put_money(current_account, card, put_amount_input)
    end
  end

  def send_money
    send_card_input(current_account) do |sender_card|
      recipient_card_number_input do |recipient_card|
        puts manager.send_money(current_account, sender_card, recipient_card, send_amount_input)
      end
    end
  end
end
