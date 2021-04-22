class Console
  DB_PATH = File.expand_path('accounts.yml', __dir__)

  include ConsoleHelper
  include AccountInputs
  include CardInputs

  def initialize
    @db_path = DB_PATH
  end

  def console
    output('hello')
    command = ConsoleCommand.new(input)
    command.valid? ? command.run(self) : exit
  end

  def main_menu
    loop do
      output('main_operations', name: @current_account.name)
      command = MainCommand.new(input)
      command.valid? ? command.run(self) : puts(command.errors)
    end
    exit
  end

  def load
    return create_the_first_account if manager.no_accounts?

    loop do
      @current_account = manager.find_by_login_password(login_input, password_input)
      @current_account ? break : output('error.user_not_exists')
    end
    main_menu
  end

  def create
    fill_account_form(manager) { |form| @current_account = form.create_account }
    main_menu
  end

  def create_card
    card_type_input { |card_type| manager.create_card(@current_account, card_type) }
  end

  def destroy_card
    destroy_card_input(@current_account) do |card|
      manager.destroy_card(@current_account, card) if confirm?('common.destroy_card', number: card.number)
    end
  end

  def show_cards
    any_cards?(@current_account) { @current_account.cards.each { |card| puts "- #{card.number}, #{card.type}" } }
  end

  def withdraw_money
    withdraw_card_input(@current_account) do |card|
      puts manager.withdraw_money(@current_account, card, withdraw_amount_input)
    end
  end

  def put_money
    put_card_input(@current_account) do |card|
      puts manager.put_money(@current_account, card, put_amount_input)
    end
  end

  def send_money
    send_card_input(@current_account) do |sender_card|
      recipient_card_number_input do |recipient_card|
        puts manager.send_money(@current_account, sender_card, recipient_card, send_amount_input)
      end
    end
  end

  def destroy_account
    confirm?('common.destroy_account') && manager.destroy_account(@current_account) && exit
  end

  def create_the_first_account
    confirm?('common.create_first_account') ? create : console
  end

  private

  def accounts
    store.load
  end

  def manager
    @manager ||= DataManager.new(store, accounts)
  end

  def store
    @store ||= YamlStore.new(@db_path)
  end
end
