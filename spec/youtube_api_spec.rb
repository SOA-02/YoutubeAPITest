# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/youtube_api'


# 在這裡定義要測試的檔案和預期的正確結果
# config = YAML.safe_load_file('../config/secrets.yml')

CONFIG = YAML.safe_load_file(File.expand_path('../config/secrets.yml', __dir__))
CORRECT = YAML.safe_load_file('spec/fixtures/youtube_channel_info.yml')

describe 'Tests Youtube Video Details' do
  before do
    @video_details = YAML.load_file('spec/fixtures/youtube_channel_info.yml')
  end

  describe 'Video information' do
    it 'HAPPY: should match all video details with correct attributes' do
      _(@video_details[:title]).must_equal CORRECT[:title]
      _(@video_details[:published_at]).must_equal CORRECT[:published_at]
      _(@video_details[:channel_title]).must_equal CORRECT[:channel_title]
      _(@video_details[:description]).must_equal CORRECT[:description]
      _(@video_details[:thumbnail_url]).must_equal CORRECT[:thumbnail_url]
    end

    it 'SAD: should raise an error for missing keys' do
      _(@video_details.key?(:invalid_key)).must_equal false
    end
  end
end
