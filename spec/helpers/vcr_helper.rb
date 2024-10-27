# frozen_string_literal: true

require 'vcr'
require 'webmock'

<<<<<<< HEAD
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  CASSETTE_FILE = 'youtube_api'
=======
# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  YOUTUBE_CASSETTE = 'youtube_api'
>>>>>>> main

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_youtube
    VCR.configure do |c|
      c.filter_sensitive_data('<API_KEY>') { API_KEY }
<<<<<<< HEAD
      c.filter_sensitive_data('<API_KEY>') { CGI.escape(API_KEY) }
    end

    VCR.insert_cassette(
      CASSETTE_FILE,
=======
      c.filter_sensitive_data('<API_KEY_ESC>') { CGI.escape(API_KEY) }
    end

    VCR.insert_cassette(
      YOUTUBE_CASSETTE,
>>>>>>> main
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
