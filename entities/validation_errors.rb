class ValidationErrors
  extend Forwardable
  include Enumerable

  def_delegators :@errors, :each, :empty?, :<<

  def initialize(errors = [])
    @errors = errors
  end

  def to_s
    @errors.join("\n")
  end
end
