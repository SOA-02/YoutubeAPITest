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

    it 'HAPPY: should be able to save remote yt repo data to database' do
      video = Outline::Youtube::VideoMapper.new(API_KEY).find(VIDEO_ID)
      rebuilt = Outline::Repository::For.entity(video).rebuild_entity(video)
      
      _(rebuilt.id).must_equal VIDEO_ID
    end
  end
end
