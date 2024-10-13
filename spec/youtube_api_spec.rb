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
    youtube_api = CodePraise::YoutubeApi.new(CONFIG['API_KEY'])
    video_id = 'jeqH4eMGjhY'
    @video_details = youtube_api.basic_channel_info(video_id).first
  end

  describe 'Video information' do
    it 'HAPPY: should match all video details with correct attributes' do
      _(@video_details.title).must_equal CORRECT['title']
      _(@video_details.published_at).must_equal CORRECT['published_at']
      _(@video_details.channel_title).must_equal CORRECT['channel_title']
      _(@video_details.description).wont_be_nil
      _(@video_details.thumbnail_url).wont_be_nil
    end

    it 'SAD: should raise an error for missing keys' do
      _(@video_details.title).wont_be_nil 
    end
  end
end
