# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module Outline
  module Entity
    # Domain entity for video
    class Video < Dry::Struct
      include Dry.Types

      attribute :id, Strict::String
      attribute :title, Strict::String
      attribute :published_at, Strict::String
      attribute :description, Strict::String
      attribute :thumbnail_url, Strict::String
      attribute :tags, Strict::Array.of(Strict::String).optional
    end
  end
end
