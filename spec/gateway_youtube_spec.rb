# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'

describe 'Tests Youtube API library' do
  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end
  describe 'Channel information' do
    before do
      # puts "API#{API_KEY}"
      @channel = Outline::Youtube::ChannelMapper
        .new(API_KEY)
        .find(CHANNEL_ID)
    end

    it 'HAPPY: should recognize channel' do
      _(@channel).must_be_kind_of Outline::Entity::Channel
    end

    it 'HAPPY: should get channel title using try' do
      _(@channel.object_id).wont_be_nil
      _(@channel.channel_title).wont_be_nil
    end
  end

  describe 'Video Information' do
    before do
      @video_data = Outline::Youtube::YoutubeApi.new(API_KEY).video_info(VIDEO_ID)
      @items_data = @video_data['items'].first
      @video_mapper = Outline::Youtube::VideoMapper.new(API_KEY).find(VIDEO_ID)
    end

    it 'HAPPY: fetches video data successfully' do
      _(@video_data).must_be_kind_of Hash
      _(@video_data['kind']).must_equal 'youtube#videoListResponse'

      _(@items_data['kind']).must_equal 'youtube#video'
      _(@items_data['id']).must_equal VIDEO_ID
    end

    it 'HAPPY: maps video data successfully' do
      _(@video_mapper).must_be_kind_of Outline::Entity::Video
    end

    it 'HAPPY: entity are of correct type' do
      _(@video_mapper.video_id).must_equal VIDEO_ID
      _(@video_mapper.video_title).must_be_kind_of String
    end
  end

  describe 'Playlist information' do
    before do
      @playlist = Outline::Youtube::PlaylistMapper
        .new(API_KEY)
        .find(PLAYLIST_ID)
    end

    it 'HAPPY: should recognize playlist' do
      _(@playlist).must_be_kind_of Outline::Entity::Playlist
    end

    # it 'HAPPY: should get playlist title using try' do
    #   _(@playlist.playlist_id).wont_be_nil
    #   _(@playlist.playlist_title).wont_be_nil

    puts "testtest123"
    # end
  end
end
