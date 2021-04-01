module AccountInputs
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
