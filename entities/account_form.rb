class AccountForm < ValidableEntity
  LOGIN_MIN_LENGTH = 4
  LOGIN_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 6
  PASSWORD_MAX_LENGTH = 30
  AGE_RANGE = (23..90).freeze

  def initialize(manager, data)
    @manager = manager
    @login = data[:login]
    @password = data[:password]
    @name = data[:name]
    @age = data[:age]
  end

  def create_account
    @manager.create_account(name: @name, age: @age, login: @login, password: @password)
  end

  private

  def validate
    validate_name
    validate_age
    validate_login
    validate_accounts_exists
    validate_password
  end

  def validate_name
    errors << I18n.t('account_validation.name.first_letter') if name_invalid?
  end

  def validate_age
    errors << I18n.t('account_validation.age.length', min: AGE_RANGE.min, max: AGE_RANGE.max) if age_invalid?
  end

  def validate_login
    errors << I18n.t('account_validation.login.present') if @login.empty?
    errors << I18n.t('account_validation.login.longer', min: LOGIN_MIN_LENGTH) if login_short?
    errors << I18n.t('account_validation.login.shorter', max: LOGIN_MAX_LENGTH) if login_long?
  end

  def validate_password
    errors << I18n.t('account_validation.password.present') if @password.empty?
    errors << I18n.t('account_validation.password.longer', min: PASSWORD_MIN_LENGTH) if password_short?
    errors << I18n.t('account_validation.password.shorter', max: PASSWORD_MAX_LENGTH) if password_long?
  end

  def validate_accounts_exists
    errors << I18n.t('account_validation.login.exists') if account_exists?
  end

  def account_exists?
    @manager.account_exists?(@login)
  end

  def login_short?
    @login.length < LOGIN_MIN_LENGTH
  end

  def login_long?
    @login.length > LOGIN_MAX_LENGTH
  end

  def password_short?
    @password.length < PASSWORD_MIN_LENGTH
  end

  def password_long?
    @password.length > PASSWORD_MAX_LENGTH
  end

  def age_invalid?
    !AGE_RANGE.cover?(@age)
  end

  def name_invalid?
    @name.empty? || @name[0].upcase != @name[0]
  end
end
