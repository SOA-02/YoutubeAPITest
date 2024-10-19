# frozen_string_literal: true

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../app/models/gateways/youtube_api'

VIDEO_ID = 'jeqH4eMGjhY'
CONFIG = YAML.safe_load_file('../config/secrets.yml')
YT_TOKEN = CONFIG['YT_TOKEN']
CORRECT = YAML.safe_load_file('../spec/fixtures/video_info_fifi.yml')

CASSETTES_FOLDER = 'fixtures/cassettes'
CASSETTE_FILE = 'yt_videos_api'
