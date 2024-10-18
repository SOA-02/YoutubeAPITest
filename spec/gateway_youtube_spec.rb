# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests Youtube API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<API_KEY>') { API_KEY }
    c.filter_sensitive_data('<API_KEY_ESC>') { CGI.escape(API_KEY) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Channel information' do
    before do
      @project = Outline::Youtube::ChannelMapper.new(API_KEY)
      @channel = @project.find(CHANNEL_ID)
    end
  
    it 'HAPPY: should recognize channel' do
      _(@channel).must_be_kind_of Outline::Entity::Channel
      puts "Channel ID: #{@channel.id}"
      puts "Channel Title: #{@channel.channel_title}"
      puts "Channel Description: #{@channel.description}"
    end
  
    it 'HAPPY: should get channel title' do
      _(@channel.id).wont_be_nil
      _(@channel.channel_title).wont_be_nil
    end
  end
  
end