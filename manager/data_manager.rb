class DataManager
  attr_reader :store, :accounts

  def initialize(store, accounts)
    @store = store
    @accounts = accounts
  end

  def create_card(account, type)
    card = BaseCard.create(type.to_sym)
    if card
      account.card << card
      update_account(account)
    end
    card
  end

  def destroy_card(account, card)
    account.card.delete(card)
    update_account(account)
  end

  def withdraw_money(account, card, amount)
    result = card.withdraw_money(amount)
    update_account(account) if result.success?
    result
  end

  def put_money(account, card, amount)
    result = card.put_money(amount)
    update_account(account) if result.success?
    result
  end

  def send_money(account, sender_card, recipient_card, amount)
    result = sender_card.send_money(amount, recipient_card)
    if result.success?
      update_account(account)
      update_card(recipient_card)
    end
    result
  end

  def update_card(new_card)
    new_accounts = accounts.map do |account|
      if account.card.any? { |card| card.number == new_card.number }
        account.card.map! { |card| card.number == new_card.number ? new_card : card }
      end
      account
    end
    store.save(new_accounts)
  end

  def create_account(params)
    new_account = Account.new(params)
    store.save(accounts << new_account)
    new_account
  end

  def update_account(new_account)
    new_accounts = accounts.map { |account| account.login == new_account.login ? new_account : account }
    store.save(new_accounts)
  end

  def remove_account(removed_account)
    new_accounts = accounts.reject { |account| account.login == removed_account.login }
    store.save(new_accounts)
  end

  def find_by_login_password(login, password)
    accounts.find { |account| login == account.login && password == account.password }
  end

  def find_card_by_number(number)
    all_cards.find { |card| card.number == number }
  end

  def card_with_number_exists?(number)
    all_cards.any? { |card| card.number == number }
  end

  def account_exists?(login)
    accounts.any? { |account| account.login == login }
  end

  def no_accounts?
    accounts.empty?
  end

  def all_cards
    accounts.map(&:card).flatten
  end
end
