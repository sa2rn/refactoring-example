class MainCommand < BaseCommand
  MAIN_COMMANDS = {
    SC: :show_cards,
    CC: :create_card,
    DC: :destroy_card,
    PM: :put_money,
    WM: :withdraw_money,
    SM: :send_money,
    DA: :destroy_account,
    exit: :leave_loop
  }.freeze

  private

  def commands
    MAIN_COMMANDS
  end
end
