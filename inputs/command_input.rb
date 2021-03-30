class CommandInput < BaseInput
  def transform(answer)
    @params[:commands][answer.to_sym]
  end

  def validate
    @error = I18n.t('error.wrong_command') unless @value
  end
end
