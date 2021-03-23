require 'yaml'
require 'pry'
require 'i18n'

I18n.load_path << Dir["#{File.expand_path('config/locales', __dir__)}/*.yml"]

require_relative 'entities/card'
require_relative 'entities/capitalist_card'
require_relative 'entities/usual_card'
require_relative 'entities/virtual_card'
require_relative 'entities/account'
require_relative 'store/yaml_store'
