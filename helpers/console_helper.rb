module ConsoleHelper
  EXIT_COMMAND = 'exit'.freeze
  CONFIRM_YES = 'y'.freeze

  def exit?(command)
    command == EXIT_COMMAND
  end

  def confirm?(message)
    puts message
    gets.chomp == CONFIRM_YES
  end

  def catch_terminate
    yield
  rescue Terminate
    nil
  end

  def terminate
    raise Terminate
  end
end
