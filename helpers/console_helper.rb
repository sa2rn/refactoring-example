module ConsoleHelper
  EXIT_COMMAND = 'exit'.freeze
  CONFIRM_YES = 'y'.freeze

  def exit?(command)
    command == EXIT_COMMAND
  end

  def confirm?(*args, **kwargs)
    puts I18n.t(*args, **kwargs)
    gets.chomp == CONFIRM_YES
  end

  def leave_loop
    raise StopIteration
  end

  def input
    gets.chomp
  end

  def output(*args, **kwargs)
    puts I18n.t(*args, **kwargs)
  end
end
