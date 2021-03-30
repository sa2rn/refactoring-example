class BaseInput
  attr_reader :error, :value

  def initialize(**kwargs)
    @params = defaults.merge(kwargs)
  end

  def defaults
    {}
  end

  def valid?
    @error.nil?
  end

  def run
    show_label
    @value = input
    show_error
    valid?
  end

  def label
    @params[:label]
  end

  private

  def input
    answer = gets.chomp
    @value = respond_to?(:transform) ? transform(answer) : answer
  end

  def show_error
    validate if respond_to?(:validate)
    puts error if error
  end

  def show_label
    puts label if label
  end
end
