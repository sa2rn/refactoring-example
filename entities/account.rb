class Account
  LOGIN_MIN_LENGTH = 4
  LOGIN_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 6
  PASSWORD_MAX_LENGTH = 30
  AGE_RANGE = (23..90).freeze

  attr_reader :login, :password, :name, :age, :card, :errors

  def initialize(params)
    @login = params[:login]
    @password = params[:password]
    @name = params[:name]
    @age = params[:age]
    @card = []
    @errors = []
  end

  def validate(manager:)
    validate_name
    validate_age
    validate_login(manager: manager)
    validate_password
  end

  def valid?(**kwargs)
    validate(**kwargs)
    @errors.empty?
  end

  def validate_name
    error('account_validation.name.first_letter') { name.empty? || name[0].upcase != name[0] }
  end

  def validate_age
    error('account_validation.age.length', min: AGE_RANGE.min, max: AGE_RANGE.max) { !AGE_RANGE.cover?(age) }
  end

  def validate_login(manager:)
    error('account_validation.login.present') { login.empty? }
    error('account_validation.login.longer', min: LOGIN_MIN_LENGTH) { login.length < LOGIN_MIN_LENGTH }
    error('account_validation.login.shorter', max: LOGIN_MAX_LENGTH) { login.length > LOGIN_MAX_LENGTH }
    error('account_validation.login.exists') { manager.account_exists?(login) }
  end

  def validate_password
    error('account_validation.password.present') { password.empty? }
    error('account_validation.password.longer', min: PASSWORD_MIN_LENGTH) { password.length < PASSWORD_MIN_LENGTH }
    error('account_validation.password.shorter', max: PASSWORD_MAX_LENGTH) { password.length > PASSWORD_MAX_LENGTH }
  end

  def error(*args, **kwargs)
    errors << I18n.t(*args, **kwargs) if yield
  end
end
