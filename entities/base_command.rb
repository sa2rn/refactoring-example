class BaseCommand < ValidableEntity
  attr_reader :command

  def initialize(command)
    @command = command.to_sym
  end

  def run(context)
    context.method(commands[command]).call
  end

  private

  def commands
    raise NotImplementedError
  end

  def validate
    errors << I18n.t('error.wrong_command') unless commands.key?(command)
  end
end
