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
      _(@video_mapper.id).must_equal VIDEO_ID
      _(@video_mapper.title).must_be_kind_of String
    end
  end

  describe 'Playlist Information' do
    before do
      @playlist_data = Outline::Youtube::YoutubeApi.new(API_KEY).playlist_info(PLAYLIST_ID)
      @items_data = @playlist_data['items'].first
      @playlist_mapper = Outline::Youtube::PlaylistMapper.new(API_KEY).find(PLAYLIST_ID)
    end

    it 'HAPPY: fetches playlist data successfully' do
      _(@playlist_data).must_be_kind_of Hash
      _(@playlist_data['kind']).must_equal 'youtube#videoListResponse'

      _(@items_data['kind']).must_equal 'youtube#playlist'
      _(@items_data['id']).must_equal PLAYLIST_ID
    end

    it 'HAPPY: maps playlist data successfully' do
      _(@playlist_mapper).must_be_kind_of Outline::Entity::Playlist
    end

    it 'HAPPY: entity are of correct type' do
      _(@playlist_mapper.id).must_equal PLAYLIST_ID
      _(@playlist_mapper.title).must_be_kind_of String
    end
  end
end
