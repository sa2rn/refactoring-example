module AccountInputs
  def login_input
    input('ask.login')
  end

  def password_input
    input('ask.password')
  end

  def name_input
    input('ask.name')
  end

  def age_input
    input('ask.age').to_i
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
end
