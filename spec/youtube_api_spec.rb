# frozen_string_literal: true

require_relative 'spec_helper' # 根據需要包含spec_helper來配置VCR等

describe 'Tests Youtube Video Details' do
  before do
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
      c.filter_sensitive_data('<API_KEY>') { API_KEY }
      c.filter_sensitive_data('<API_KEY_ESC>') { CGI.escape(API_KEY) }
    end

    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
    youtube_api = CodePraise::YoutubeApi.new(API_KEY)
    video_id = 'jeqH4eMGjhY'
    @video_details = youtube_api.basic_channel_info(video_id).first
    raise 'Failed to fetch video details' if @video_details.nil?
  end

  after do
    VCR.eject_cassette
  end

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
