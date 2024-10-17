# frozen_string_literal: true

require 'roda'
require 'yaml'

module CodePraise
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load_file('config/secrets.yml')
    API_KEY = CONFIG['API_KEY']
  end
end