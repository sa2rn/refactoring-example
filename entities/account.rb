class Account
  attr_reader :login, :password, :name, :age, :card

  def initialize(login, password, name, age)
    @login = login
    @password = password
    @name = name
    @age = age
    @card = []
  end
end
