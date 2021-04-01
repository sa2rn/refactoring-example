class Account
  attr_reader :login, :password, :name, :age, :card

  def initialize(params)
    @login = params[:login]
    @password = params[:password]
    @name = params[:name]
    @age = params[:age]
    @card = []
  end
end
