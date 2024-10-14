# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module CodePraise
  module Entity
    # Domain entity for channel
    class Channel < Dry::Struct
      include Dry.Types

      attribute? :id, Strict::String.optional
      attribute :title, Strict::String
      attribute :published_at, Strict::String
      attribute :channel_title, Strict::String
      attribute :description, Strict::String
      attribute :thumbnail_url, Strict::String
      attribute :tags, Strict::Array.of(Strict::String).optional
    end
  end
end
