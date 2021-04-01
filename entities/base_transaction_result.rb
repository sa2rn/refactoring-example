class BaseTransactionResult
  attr_reader :errors

  def initialize(params)
    @card = params[:card]
    @amount = params[:amount]
    @errors = params[:errors]
  end

  def message
    raise NotImplementedError
  end

  def success?
    @errors&.empty?
  end
end
