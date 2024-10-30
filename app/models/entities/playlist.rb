# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Outline
  module Entity
    # domain entity for playlist
    class Playlist < Dry::Struct
      include Dry.Types
      attribute :id, Integer.optional
      attribute :playlist_id, Strict::String.optional
      attribute :playlist_title, Strict::String.optional
      attribute :playlist_published_at, Strict::String.optional
      attribute :playlist_description, Strict::String.optional
      attribute :playlist_thumbnail_url, Strict::String.optional

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
