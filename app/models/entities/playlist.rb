# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Outline
  module Entity 
    # domain entity for playlist
    class Playlist < Dry::Struct
      include Dry.types

      attribute :playlist_id, Strict::String
      attribute? :playlist_title, Strict::String
      attribute? :playlist_published_at, Strict::Time
      attribute? :playlist_description, Strict::String
      attribute? :playlist_thumbnail_url, Strict::String
      attribute? :playlist_item_count, Strict::Integer
      # attribute? :playlist_item_id, Strict::list
      # attribute? :playlist_item_title, Strict::list

    end








