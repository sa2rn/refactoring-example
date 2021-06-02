module AccountConsole
  def load
    return create_the_first_account if manager.no_accounts?

    loop { break if load_account }
    main_menu
  end

  def create
    fill_account_form(manager) { |form| change_current_account(form.create_account) }
    main_menu
  end

  def destroy_account
    confirm?('common.destroy_account') && manager.destroy_account(current_account) && exit
  end

  def create_the_first_account
    confirm?('common.create_first_account') ? create : console
  end

  private

  def load_account
    account = manager.find_by_login_password(login_input, password_input)
    output('error.user_not_exists') unless account
    change_current_account(account)
  end
end
