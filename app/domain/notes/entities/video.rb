# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Outline
  module Entity
    # Domain entity for video
    class Video < Dry::Struct
      include Dry.Types

      attribute :id, Integer.optional
      attribute :video_id, Strict::String
      attribute :video_title, Strict::String
      attribute :video_published_at, Strict::String
      attribute :video_description, Strict::String
      attribute :video_thumbnail_url, Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
