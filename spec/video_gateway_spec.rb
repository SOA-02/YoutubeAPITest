# frozen_string_literal: true

require_relative 'fifi_gateway_spec_helper'

describe 'Tests Youtube API' do
  # set up folder
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<YT_TOKEN>') { YT_TOKEN }
    c.filter_sensitive_data('<YT_TOKEN_ESC>') { CGI.escape(YT_TOKEN) }
  end

  # record each test
  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Video gateway' do
    before do
      @video_data = Outline::Youtube::YoutubeApi.new(YT_TOKEN).video_info(VIDEO_ID)
      @items_data = @video_data['items'].first
      #puts @items_data
      @snippet = @items_data['snippet']
    end

    it 'HAPPY: fetches video data successfully' do
      _(@video_data).must_be_kind_of Hash
      _(@video_data['kind']).must_equal 'youtube#videoListResponse'
      _(@video_data['items']).must_be_kind_of Array

      _(@items_data['kind']).must_equal 'youtube#video'
      _(@items_data['id']).must_equal VIDEO_ID
     
      _(@snippet['title']).wont_be_nil
      _(@snippet['description']).wont_be_nil
      _(@snippet['publishedAt']).wont_be_nil
      _(@snippet['thumbnails']).must_be_kind_of Hash
      _(@snippet['tags']).must_be_kind_of Array
    end

    it 'SAD: NotFound error on invalid video id' do
      
    end
  end

  describe 'Video Mapper' do
    it 'HAPPY: should find video and build entity' do
      
    end
    it 'HAPPY: map video data to video entity' do
      
    end
  end

  describe 'Video Entity' do
    it 'HAPPY: should create a valid entity' do
      
    end
  end
end