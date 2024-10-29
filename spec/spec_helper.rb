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

CHANNEL_ID = 'UCpYf6C9QsP_BRf97vLuXlIA'
VIDEO_ID = 'GZe2FJOWGIs'
PLAYLIST_ID = 'PLBlnK6fEyqRh5OzEIQOQ0-hx3rNHxsDvz'
API_KEY = Outline::App.config.API_KEY
puts 'API=>>>>'+API_KEY
CORRECT = YAML.safe_load_file('spec/fixtures/youtube_channel_info.yml')
