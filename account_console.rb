class AccountConsole
  FILE_PATH = File.expand_path('accounts.yml', __dir__)
  LOGIN_MIN_LENGTH = 4
  LOGIN_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 6
  PASSWORD_MAX_LENGTH = 30
  AGE_RANGE = (23..90).freeze

  attr_accessor :login, :name, :card, :password, :file_path

  def initialize(file_path: FILE_PATH)
    @errors = []
    @file_path = file_path
  end

  def console
    puts I18n.t('hello')
    case gets.chomp
    when 'create' then create
    when 'load' then load
    else
      exit
    end
  end

  def create
    loop do
      name_input
      age_input
      login_input
      password_input
      break if @errors.empty?

      @errors.each { |error| puts error }.clear
    end
    @current_account = new Account(name: @name, age: @age, login: @login, password: @password)
    store.save(accounts << @current_account)
    main_menu
  end

  def load
    return create_the_first_account if accounts.empty?

    loop do
      puts I18n.t('ask.login')
      login = gets.chomp
      puts I18n.t('ask.password')
      password = gets.chomp
      @current_account = accounts.find { |account| login == account.login && password === account.password }
      break if @current_account

      puts I18n.t('error.user_not_exists')
    end
    main_menu
  end

  def create_the_first_account
    return create if confirm?(I18n.t('common.create_first_account'))

    console
  end

  def main_menu
    loop do
      puts I18n.t('main_operations', name: @current_account.name)

      case gets.chomp
      when 'SC' then show_cards
      when 'CC' then create_card
      when 'DC' then destroy_card
      when 'PM' then put_money
      when 'WM' then withdraw_money
      when 'SM' then send_money
      when 'DA' then destroy_account
      when 'exit'
        exit
        break
      else
        puts I18n.t('error.wrong_command')
      end
    end
  end

  def create_card
    card_type = enter_card_type
    @current_account.card << Card.create(card_type)
    new_accounts = accounts.map { |account| account.login == @current_account.login ? @current_account : account }
    store.save(new_accounts)
  end

  def destroy_card
    current_card = choose_card('If you want to delete:')
    return unless current_card

    if confirm?("Are you sure you want to delete #{current_card.number}?[y/n]")
      @current_account.card.delete_at(answer&.to_i.to_i - 1)
      new_accounts = accounts.map { |account| account.login == @current_account.login ? @current_account : account }
      store.save(new_accounts)
    end
  end

  def show_cards
    return unless any_card?

    @current_account.card.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  def withdraw_money
    current_card = choose_card('Choose the card for withdrawing:')
    amount = current_card && enter_money_amount('Input the amount of money you want to put on your card')
    return unless current_card && amount

    result = current_card.withdraw_money(amount)
    new_accounts = accounts.map { |account| account.login == @current_account.login ? @current_account : account }
    store.save(new_accounts)
    puts result
  end

  def put_money
    current_card = choose_card('Choose the card for putting:')
    amount = current_card && enter_money_amount('Input the amount of money you want to put on your card')
    return unless current_card && amount

    result = current_card.put_money(amount)
    new_accounts = accounts.map { |account| account.login == @current_account.login ? @current_account : account }
    store.save(new_accounts)
    puts result
  end

  def send_money
    sender_card = choose_card('Choose the card for sending:')
    recipient_card = sender_card && enter_card_number
    return unless sender_card && recipient_card

    loop do
      money = enter_money_amount
      next unless money

      begin
        result = sender_card.send_money(amount, recipient_balance)
        @current_account.card.map! { |card| card.number == sender_card.number }
        new_accounts = accounts.map do |account|
          if account.login == @current_account.login
            current_account
          elsif account.card.any? { |card| card.number == recipient_card.number }
            account.card.map! { |card| card.number == recipient_card.number ? recipient_card : card }
            account
          else
            account
          end
        end
        store.save(new_accounts)
        puts result
        break
      rescue StandardError => e
        puts e.message
      end
    end
  end

  def destroy_account
    if confirm?('Are you sure you want to destroy account?[y/n]')
      new_accounts = accounts.filter { |account| account.login != @current_account.login }
      store.save(new_accounts)
    end
    exit
  end

  private

  def enter_card_type
    loop do
      puts I18n.t('create_card')

      # TODO: exit
      card_type = gets.chomp
      return card_type if Card::CARD_TYPES.any?(card_type)

      puts I18n.t('error.wrong_card_type')
    end
  end

  def confirm?(message)
    puts message
    gets.chomp == 'y'
  end

  def enter_money_amount(message)
    puts message
    amount = gets.chomp.to_i
    return amount if amount.positive?

    puts I18n.t('error.correct_amount')
  end

  def any_card?
    return true if @current_account.card.any?

    puts I18n.t('error.no_active_cards')
    false
  end

  def choose_card(message)
    return unless any_card?

    puts message
    @current_account.card.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
    puts I18n.t('common.press_exit')
    loop do
      answer = gets.chomp
      break if answer == 'exit'

      index = answer.to_i - 1
      return  @current_account.card[index] if @current_account.card.each_index.any?(index)

      puts I18n.t('error.wrong_number')
    end
  end

  def enter_card_number
    puts I18n.t('ask.recipient_card')
    recipient_card_number = gets.chomp
    if recipient_card_number.length == Card::NUMBER_LENGTH
      recipient_card = all_cards.find { |card| card.number == recipient_card_number }
      return recipient_card if recipient_card

      puts I18n.t('error.no_card_with_number', number: recipient_card_number)
    else
      puts I18n.t('error.wrong_card_number')
    end
  end

  def name_input
    puts I18n.t('ask.name')
    @name = gets.chomp
    @errors << I18n.t('account_validation.name.first_name') if @name.empty? || @name[0].upcase != @name[0]
  end

  def login_input
    puts I18n.t('ask.login')
    @login = gets.chomp
    @errors << I18n.t('account_validation.login.present') if @login.empty?
    @errors << I18n.t('account_validation.login.longer', min: LOGIN_MIN_LENGTH) if @login.length < LOGIN_MIN_LENGTH
    @errors << I18n.t('account_validation.login.shorter', max: LOGIN_MAX_LENGTH) if @login.length > LOGIN_MAX_LENGTH
    @errors << I18n.t('account_validation.login.exists') if accounts.any { |account| account.login == @login }
  end

  def password_input
    puts I18n.t('ask.password')
    @password = gets.chomp
    @errors << I18n.t('account_validation.password.present') if @password.empty?
    @errors << I18n.t('account_validation.password.longer', min: PASSWORD_MIN_LENGTH) if @password.length < PASSWORD_MIN_LENGTH
    @errors << I18n.t('account_validation.password.shorter', max: PASSWORD_MAX_LENGTH) if @password.length > PASSWORD_MAX_LENGTH
  end

  def age_input
    puts I18n.t('ask.age')
    @age = gets.chomp.to_i
    @errors << I18n.t('account_validation.password.length', min: AGE_RANGE.min, max: AGE_RANGE.max) unless AGE_RANGE.cover?(@age)
  end

  def store
    @store = YamlStore.new(file_path)
  end

  def accounts
    store.load
  end

  def all_cards
    accounts.map(&:card).flatten
  end
end
