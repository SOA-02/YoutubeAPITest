# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'

module Outline
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load_file('config/secrets.yml')
    API_KEY = CONFIG['API_KEY']
  end
end

module Outline
  class Api < Roda
    plugin :environments

    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load

    def self.config = Figaro.env
  end
end
