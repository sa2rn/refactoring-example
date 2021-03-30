class NumberInput < BaseInput
  def transform(answer)
    answer.to_i
  end
end
