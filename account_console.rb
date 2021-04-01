class AccountConsole
  include ConsoleHelper
  include Inputs

  FILE_PATH = File.expand_path('accounts.yml', __dir__)

  def initialize
    @file_path = FILE_PATH
  end

  def console
    output('hello')
    command = ConsoleCommand.new(input)
    if command.valid?
      command.run(self)
    else
      exit
    end
  end

  def main_menu
    loop do
      output('main_operations', name: @current_account.name)
      command = MainCommand.new(input)
      if command.valid?
        command.run(self)
      else
        puts command.errors
      end
    end
    exit
  end

  def load
    return create_the_first_account if manager.no_accounts?

    loop do
      @current_account = manager.find_by_login_password(login_input, password_input)
      break if @current_account

      output('error.user_not_exists')
    end
    main_menu
  end

  def create
    loop do
      form = AccountForm.new(manager, account_form_data)
      if form.valid?
        @current_account = form.create_account
        break
      end
      puts form.errors
    end
    main_menu
  end

  def create_card
    loop do
      output('create_card')
      card_type = input
      return if exit?(card_type) || manager.create_card(@current_account, card_type)

      output('error.wrong_card_type')
    end
  end

  def destroy_card
    any_cards? do
      output('common.if_you_want_to_delete')
      select_card_input(@current_account) do |card|
        manager.destroy_card(@current_account, card) if confirm_delete?(card)
      end
    end
  end

  def show_cards
    any_cards? do
      @current_account.card.each { |card| puts "- #{card.number}, #{card.type}" }
    end
  end

  def withdraw_money
    any_cards? do
      output('common.choose_card_withdrawing')
      select_card_input(@current_account) do |card|
        output('common.withdraw_amount')
        result = manager.withdraw_money(@current_account, card, input.to_i)
        puts result.success? ? result.message : result.errors
      end
    end
  end

  def put_money
    any_cards? do
      output('common.choose_card')
      select_card_input(@current_account) do |card|
        output('common.input_amount')
        result = manager.put_money(@current_account, card, input.to_i)
        puts result.success? ? result.message : result.errors
      end
    end
  end

  def send_money
    any_cards? do
      output('common.choose_card_sending')
      select_card_input(@current_account) do |sender_card|
        output('common.recipient_card')
        card_number_input do |recipient_card|
          output('common.input_amount')
          result = manager.send_money(@current_account, sender_card, recipient_card, input.to_i)
          puts result.success? ? result.message : result.errors
        end
      end
    end
  end

  def destroy_account
    manager.remove_account(@current_account) if confirm?('common.destroy_account')
    exit
  end

  def create_the_first_account
    confirm?('common.create_first_account') ? create : console
  end

  private

  def confirm_delete?(card)
    confirm?('common.destroy_card', number: card.number)
  end

  def any_cards?
    if @current_account.card.any?
      yield
    else
      output('error.no_active_cards')
    end
  end

  def accounts
    store.load
  end

  def manager
    @manager ||= DataManager.new(store, accounts)
  end

  def store
    @store ||= YamlStore.new(@file_path)
  end
end
