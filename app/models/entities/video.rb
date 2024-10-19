# frozen_string_literal: true

#require 'dry-types'
require 'dry-struct'

module Outline
  module Entity
    # Domain entity for video
    class Video < Dry::Struct
      include Dry.Types

      attribute :video_id, Strict::String
      attribute :video_title, Strict::String
      attribute :video_published_at, Strict::Time
      attribute :video_description, Strict::String
      attribute :video_thumbnail_url, Strict::String
      attribute :video_tags, Strict::Array.of(Strict::String).optional
    end
  end
end
