class RootConsole < BaseConsole
  FILE_PATH = File.expand_path('../accounts.yml', __dir__)
  MAIN_COMMANDS = {
    SC: :show_cards,
    CC: :create_card,
    DC: :destroy_card,
    PM: :put_money,
    WM: :withdraw_money,
    SM: :send_money,
    DA: :destroy_account,
    exit: :exit
  }.freeze
  CONSOLE_COMMANDS = {
    create: :create,
    load: :load,
    exit: :exit
  }.freeze

  extend Forwardable

  attr_reader :current_account

  def_delegators :account_console, :create, :load, :destroy_account
  def_delegators :card_console, :create_card, :show_cards, :destroy_card
  def_delegators :money_console, :put_money, :withdraw_money, :send_money

  def initialize
    @file_path = FILE_PATH
  end

  def console
    puts I18n.t('hello')
    console_command_input.run ? run_console_command : exit
  end

  def main_menu
    loop do
      puts I18n.t('main_operations', name: @current_account.name)
      run_main_command if main_command_input.run
    end
  end

  def manager
    @manager ||= DataManager.new(store)
  end

  def store
    @store ||= YamlStore.new(@file_path)
  end

  def change_current_account(account)
    @current_account = account
  end

  private

  def account_console
    @account_console ||= AccountConsole.new(self)
  end

  def card_console
    @card_console ||= CardConsole.new(self)
  end

  def money_console
    @money_console ||= MoneyConsole.new(self)
  end

  def run_main_command
    catch_terminate do
      method(main_command_input.value).call
    end
  end

  def run_console_command
    method(console_command_input.value).call
  end

  def main_command_input
    @main_command_input ||= CommandInput.new(commands: MAIN_COMMANDS)
  end

  def console_command_input
    @console_command_input ||= CommandInput.new(commands: CONSOLE_COMMANDS)
  end
end
