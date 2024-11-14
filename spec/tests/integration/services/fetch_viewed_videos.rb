# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'OutSpace Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Outpace show video' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return videos that are being watched' do
      # GIVEN: a valid video exists locally and is being watched
      yt_video = Outline::Youtube::VideoMapper
        .new(API_KEY)
        .find(VIDEO_ID)
      db_video = Outline::Repository::For.entity(yt_video)
        .create(yt_video)

      binding.irb # 在這裡檢查 yt_video 和 db_video 的內容

      watched_list = [VIDEO_ID]

      # WHEN: we request a list of all watched videos
      result = Outline::Service::FetchViewedVideos.new.call(watched_list)

      binding.irb # 在這裡檢查 result 和 videos 的內容

      # THEN: we should see our video in the resulting list
      _(result.success?).must_equal true
      videos = result.value!
      _(videos).must_include db_video
    end

    it 'HAPPY: should not return videos that are not being watched' do
      # GIVEN: a valid project exists locally but is not being watched
      yt_video = Outline::Youtube::VideoMapper
        .new(API_KEY)
        .find(VIDEO_ID)
      Outline::Repository::For.entity(yt_video)
        .create(yt_video)

      watched_list = []

      # WHEN: we request a list of all watched projects
      result = Outline::Service::FetchViewedVideos.new.call(watched_list)


      # THEN: it should return an empty list
      _(result.success?).must_equal true
      videos = result.value!
      _(videos).must_equal []
    end

    it 'SAD: should not watched videos if they are not loaded' do
      # GIVEN: we are watching a project that does not exist locally
      watched_list = [VIDEO_ID]

      # WHEN: we request a list of all watched projects
      result = Outline::Service::FetchViewedVideos.new.call(watched_list)


      # THEN: it should return an empty list
      _(result.success?).must_equal true
      videos = result.value!
      _(videos).must_equal []
    end
  end
end
