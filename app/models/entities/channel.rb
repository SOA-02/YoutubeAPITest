# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Outline
  module Entity
    # Domain entity for channel
    class Channel < Dry::Struct
      include Dry.Types
      # optional僅是為了資料庫簡單建檔測試
      attribute :id, Integer.optional
      attribute :origin_id, Strict::String.optional
      attribute :channel_title, Strict::String
      attribute :description, Strict::String.optional
      attribute :custom_url, Strict::String.optional
      attribute :country, Strict::String.optional
      attribute :localized_title, Strict::String.optional
      attribute :localized_description, Strict::String.optional
      attribute :subscriber_count, Strict::Integer.optional
      attribute :video_count, Strict::Integer.optional
      attribute :view_count, Strict::Integer.optional

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
