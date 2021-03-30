class AccountConsole < BaseConsole
  extend Forwardable

  def_delegators :@root, :manager, :main_menu, :change_current_account, :current_account

  def initialize(root)
    @root = root
  end

  def create
    loop do
      fill_account_form
      break if create_account
    end
    main_menu
  end

  def load
    return create_the_first_account if manager.no_accounts?

    loop do
      login_input.run
      password_input.run
      break if sign_in
    end
    main_menu
  end

  def destroy_account
    manager.remove_account(current_account) if confirm?(I18n.t('destroy_account'))
    exit
  end

  private

  def create_the_first_account
    return create if confirm?(I18n.t('common.create_first_account'))

    console
  end

  def create_account
    account = Account.new(account_form_data)
    if account.valid?(manager: manager)
      manager.create_account(account)
      change_current_account(account)
    else
      puts account.errors.join("\n")
    end
  end

  def sign_in
    account = manager.find_by_login_password(login_input.value, password_input.value)
    return change_current_account(account) if account

    puts I18n.t('error.user_not_exists')
  end

  def fill_account_form
    name_input.run
    age_input.run
    login_input.run
    password_input.run
  end

  def account_form_data
    {
      name: name_input.value,
      age: age_input.value,
      login: login_input.value,
      password: password_input.value
    }
  end

  def name_input
    @name_input ||= BaseInput.new(label: I18n.t('ask.name'))
  end

  def login_input
    @login_input ||= BaseInput.new(label: I18n.t('ask.login'))
  end

  def password_input
    @password_input ||= BaseInput.new(label: I18n.t('ask.password'))
  end

  def age_input
    @age_input ||= NumberInput.new(label: I18n.t('ask.age'))
  end
end
