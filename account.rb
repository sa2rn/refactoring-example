require_relative 'dependencies'

class AccountConsole
  FILE_PATH = File.expand_path('accounts.yml', __dir__)

  attr_reader :login, :name, :card, :password, :file_path

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

    @current_account = Account.new(@login, @password, @name, @age)
    accounts << @current_account
    save
    main_menu
  end

  def load
    loop do
      return create_the_first_account if accounts.empty?

      puts I18n.t('enter_login')
      login = gets.chomp
      puts I18n.t('enter_password')
      password = gets.chomp

      @current_account = find_account_by_login_password(login, password)
      break if @current_account

      puts 'There is no account with given credentials'
    end
    main_menu
  end

  def create_the_first_account
    puts 'There is no active accounts, do you want to be the first?[y/n]'
    if gets.chomp == 'y'
      create
    else
      console
    end
  end

  def main_menu
    loop do
      puts I18n.t('account_menu', name: @current_account.name)

      case gets.chomp
      when 'SC' then show_cards
      when 'CC' then create_card
      when 'DC' then destroy_card
      when 'PM' then put_money
      when 'WM' then withdraw_money
      when 'SM' then send_money
      when 'DA'
        destroy_account
        exit
      when 'exit'
        exit
        break
      else
        puts I18n.t('errors.wrong_command')
      end
    end
  end

  def create_card
    loop do
      puts I18n.t('create_card_menu')

      card_type = gets.chomp
      if %w[usual capitalist virtual].include?(card_type)
        case card_type
        when 'usual' then card = UsualCard.new
        when 'capitalist' then card = CapitalistCard.new
        when 'virtual' then card = VirtualCard.new
        end
        @current_account.card << card
        save
        break
      else
        puts "Wrong card type. Try again!\n"
      end
    end
  end

  def destroy_card
    if @current_account.card.empty?
      puts "There is no active cards!\n"
      return
    end

    loop do
      puts 'If you want to delete:'

      @current_account.card.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index + 1}" }
      puts "press `exit` to exit\n"
      answer = gets.chomp
      break if answer == 'exit'

      card_chooce = answer.to_i

      if card_chooce <= @current_account.card.length && card_chooce.positive?
        puts "Are you sure you want to delete #{@current_account.card[card_chooce - 1].number}?[y/n]"
        return unless gets.chomp == 'y'

        @current_account.card.delete_at(card_chooce - 1)
        save
        break
      else
        puts "You entered wrong number!\n"
      end
    end
  end

  def show_cards
    if @current_account.card.empty?
      puts "There is no active cards!\n"
    else
      @current_account.card.each { |card| puts "- #{card.number}, #{card.type}" }
    end
  end

  def withdraw_money
    puts 'Choose the card for withdrawing:'
    if @current_account.card.empty?
      puts "There is no active cards!\n"
      return
    end

    @current_account.card.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index + 1}" }
    puts "press `exit` to exit\n"
    loop do
      answer = gets.chomp
      break if answer == 'exit'

      if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i.positive?
        current_card = @current_account.card[answer&.to_i.to_i - 1]
        loop do
          puts 'Input the amount of money you want to withdraw'
          a2 = gets.chomp.to_i
          if a2&.to_i.to_i.positive?
            begin
              current_card.withdraw_money(a2&.to_i.to_i)
              save
              puts "Money #{a2&.to_i.to_i} withdrawed from #{current_card.number}$. Money left: #{current_card.balance}$. Tax: #{current_card.withdraw_tax(a2&.to_i.to_i)}$"
            rescue NotEnoughMoneyError => e
              puts e.message
              return
            end
          else
            puts 'You must input correct amount of $'
            return
          end
        end
      else
        puts "You entered wrong number!\n"
        return
      end
    end
  end

  def put_money
    puts 'Choose the card for putting:'

    if @current_account.card.any?
      @current_account.card.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index + 1}" }
      puts "press `exit` to exit\n"
      loop do
        answer = gets.chomp
        break if answer == 'exit'

        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i.positive?
          current_card = @current_account.card[answer&.to_i.to_i - 1]
          loop do
            puts 'Input the amount of money you want to put on your card'
            a2 = gets.chomp
            if a2&.to_i.to_i.positive?
              if current_card.put_tax(a2&.to_i.to_i) >= a2&.to_i.to_i
                puts 'Your tax is higher than input amount'
                return
              else
                current_card.put_money(a2&.to_i.to_i)
                @current_account.card[answer&.to_i.to_i - 1] = current_card
                save
                puts "Money #{a2&.to_i.to_i} was put on #{current_card.number}. Balance: #{current_card.balance}. Tax: #{current_card.put_tax(a2&.to_i.to_i)}"
                return
              end
            else
              puts 'You must input correct amount of money'
              return
            end
          end
        else
          puts "You entered wrong number!\n"
          return
        end
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def send_money
    puts 'Choose the card for sending:'

    if @current_account.card.empty?
      puts "There is no active cards!\n"
      return
    end

    @current_account.card.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index + 1}" }
    puts "press `exit` to exit\n"
    answer = gets.chomp
    exit if answer == 'exit'
    if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i.positive?
      sender_card = @current_account.card[answer&.to_i.to_i - 1]
    else
      puts 'Choose correct card'
      return
    end

    puts 'Enter the recipient card:'
    a2 = gets.chomp
    unless a2.length > 15 && a2.length < 17
      puts 'Please, input correct number of card'
      return
    end
    recipient_card = find_card_by_number(a2)
    unless recipient_card
      puts "There is no card with number #{a2}\n"
      return
    end

    loop do
      puts 'Input the amount of money you want to withdraw'
      a3 = gets.chomp
      if a3&.to_i.to_i.positive?
        card.send_money(recipient_card)
        puts "Money #{a3&.to_i.to_i}$ was put on #{recipient_card.number}. Balance: #{recipient_card.balance}. Tax: #{recipient_card.put_tax(a3&.to_i.to_i)}$\n"
        puts "Money #{a3&.to_i.to_i}$ was put on #{a2}. Balance: #{sender_card.balance}. Tax: #{sender_card.sender_tax(a3&.to_i.to_i)}$\n"
        break
      else
        puts 'You entered wrong number!\n'
      end
    end
  end

  def destroy_account
    puts 'Are you sure you want to destroy account?[y/n]'
    return unless gets.chomp == 'y'

    accounts.delete(@current_account)
    save
  end

  private

  def name_input
    puts 'Enter your name'
    @name = gets.chomp
    return if @name != '' && @name[0].upcase == @name[0]

    @errors << 'Your name must not be empty and starts with first upcase letter'
  end

  def login_input
    puts 'Enter your login'
    @login = gets.chomp
    @errors << 'Login must present' if @login == ''
    @errors << 'Login must be longer then 4 symbols' if @login.length < 4
    @errors << 'Login must be shorter then 20 symbols' if @login.length > 20
    @errors << 'Such account is already exists' if accounts.any? { |account| account.login == @login }
  end

  def password_input
    puts 'Enter your password'
    @password = gets.chomp
    @errors << 'Password must present' if @password == ''
    @errors << 'Password must be longer then 6 symbols' if @password.length < 6
    @errors << 'Password must be shorter then 30 symbols' if @password.length > 30
  end

  def age_input
    puts 'Enter your age'
    @age = gets.chomp
    if @age.to_i.is_a?(Integer) && @age.to_i >= 23 && @age.to_i <= 90
      @age = @age.to_i
    else
      @errors << 'Your Age must be greeter then 23 and lower then 90'
    end
  end

  def accounts
    @accounts ||= store.load
  end

  def store
    @store ||= YamlStore.new(file_path)
  end

  def save
    store.save(accounts)
  end

  def find_account_by_login_password(login, password)
    accounts.find { |account| account.login == login && account.password == password }
  end

  def all_cards
    accounts.map(&:card).flatten
  end

  def find_card_by_number(card_number)
    all_cards.find { |card| card.number == card_number }
  end
end
