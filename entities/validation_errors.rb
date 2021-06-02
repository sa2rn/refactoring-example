class ValidationErrors
  extend Forwardable
  include Enumerable

  NEW_LINE = "\n".freeze

  def_delegators :@errors, :each, :empty?, :<<

  def initialize(errors = [])
    @errors = errors
  end

  def to_s
    @errors.join(NEW_LINE)
  end
end
