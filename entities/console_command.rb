class ConsoleCommand < BaseCommand
  CONSOLE_COMMANDS = {
    create: :create,
    load: :load,
    exit: :exit
  }.freeze

  private

  def commands
    CONSOLE_COMMANDS
  end
end
