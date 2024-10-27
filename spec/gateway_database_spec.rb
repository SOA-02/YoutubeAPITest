# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Youtube API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Video Information' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: save yt api to database' do
      video = Outline::Youtube::VideoMapper.new(API_KEY).find(VIDEO_ID)
      _(video).must_be_kind_of Outline::Entity::Video

      test_find = Outline::Repository::For.entity(video).find(video)
      rebuilt = Outline::Repository::For.entity(video).create(video)
      
      # _(rebuilt.video_id).must_equal(video.video_id)
      # _(rebuilt.video_title).must_equal(video.video_title)
    end
  end
end
