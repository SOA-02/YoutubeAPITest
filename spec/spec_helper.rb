# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/unit' # minitest Github issue #17 requires
require 'minitest/rg'
require 'vcr'
require 'webmock'

# require_relative '../lib/youtube_api'

require_relative '../require_app'
require_app


CONFIG = YAML.safe_load_file(File.expand_path('../config/secrets.yml', __dir__))
CORRECT = YAML.safe_load_file('spec/fixtures/youtube_channel_info.yml')
API_KEY = CONFIG['API_KEY']
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'youtube_api'
CHANNEL_ID = 'UC_x5XG1OV2P6uZZ5FSM9Ttw'
VIEDO_ID = 'jeqH4eMGjhY'