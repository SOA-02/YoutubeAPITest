# frozen_string_literal: true

# Contains libraries and constants
require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/playlist_processor'

CONFIG = YAML.safe_load_file('config/secrets.yml')
YOUTUBE_API_KEY = CONFIG['YOUTUBE_API_KEY']
CORRECT = YAML.safe_load_file('spec/fixtures/playlist_results.yml')

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'check_YTapi_casette'
