# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

# 載入 secrets.yml 設定
CONFIG = YAML.safe_load_file(File.expand_path('../config/secrets.yml', __dir__))

# 根據執行環境 (development, test, production) 取得對應的 API_KEY
environment = ENV['RACK_ENV'] || 'development' # 預設為 development
API_KEY = CONFIG[environment]['API_KEY']

# 輸出檢查是否正確載入 API_KEY
puts "Loaded API_KEY: #{API_KEY}"

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
# CASSETTE_FILE = 'youtube_api'
CHANNEL_ID = 'UCpYf6C9QsP_BRf97vLuXlIA'
VIDEO_ID = 'jeqH4eMGjhY'
PLAYLIST_ID = 'PLBlnK6fEyqRjC2nTHdeUtWFkoiPVespkc'
