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
      puts "API KEY#{API_KEY}"
      @channel = Outline::Youtube::ChannelMapper
        .new(API_KEY)
        .find(CHANNEL_ID)
    end

    it 'HAPPY: should recognize channel' do
      _(@channel).must_be_kind_of Outline::Entity::Channel
      puts "Channel ID: #{@channel.id}"
      puts "Channel Title: #{@channel.channel_title}"
      puts "Channel Description: #{@channel.description}"
    end

    it 'HAPPY: should get channel title using try' do
      _(@channel.object_id).wont_be_nil
      _(@channel.channel_title).wont_be_nil
    end
  end
end
