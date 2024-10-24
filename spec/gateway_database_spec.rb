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

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save video from Youtube to database' do
      video = Outline::Youtube::VideoMapper.new(API_KEY).find(VIDEO_ID)

      rebuilt = Outline::Repository::For.entity(video).create(video)

      _(rebuilt.id).must_equal(video.id)
      _(rebuilt.title).must_equal(video.title)
      _(rebuilt.description).must_equal(video.description)
      _(rebuilt.published_at).must_equal(video.published_at)
      _(rebuilt.thumbnail_url).must_equal(video.thumbnail_url)
      _(rebuilt.tags).must_equal(video.tags)
    end
  end
end
