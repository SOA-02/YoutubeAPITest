# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Outline
  module Entity
    # Domain entity for channel
    class Channel < Dry::Struct
      include Dry.Types

      attribute? :id, Strict::String
      attribute :channel_title, Strict::String
      attribute :description, Strict::String
      attribute :country, Strict::String
      attribute :localized_title, Strict::String.optional
      attribute :localized_description, Strict::String.optional
      attribute :subscriber_count, Strict::Integer
      attribute :video_count, Strict::Integer
      attribute :view_count, Strict::Integer
    end
  end
end
