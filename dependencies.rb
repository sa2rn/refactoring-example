require 'yaml'
require 'pry'
require 'i18n'

I18n.load_path << Dir["#{File.expand_path('config/locales', __dir__)}/*.yml"]
I18n.default_locale = :en

require_relative 'errors/terminate'
require_relative 'helpers/console_helper'
require_relative 'helpers/inputs_helper'
require_relative 'store/yaml_store'
require_relative 'manager/data_manager'

require_relative 'entities/base_card'
require_relative 'entities/usual_card'
require_relative 'entities/virtual_card'
require_relative 'entities/capitalist_card'

require_relative 'entities/validable_entity'
require_relative 'entities/base_transaction'
require_relative 'entities/base_transaction_result'
require_relative 'entities/put_transaction_result'
require_relative 'entities/put_transaction'
require_relative 'entities/withdraw_transaction_result'
require_relative 'entities/withdraw_transaction'
require_relative 'entities/send_transaction_result'
require_relative 'entities/send_transaction'

require_relative 'entities/base_command'
require_relative 'entities/console_command'
require_relative 'entities/main_command'

require_relative 'entities/card_number'
require_relative 'entities/account_form'
require_relative 'entities/card_select'
require_relative 'entities/account'
require_relative 'entities/card_type'
require_relative 'entities/validation_errors'

require_relative 'account_console'
