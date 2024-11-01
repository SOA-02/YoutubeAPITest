# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Outline
  module Entity
    # Domain entity for search
    class Search < Dry::Struct
      include Dry.Types
      # optional僅是為了資料庫簡單建檔測試
      attribute :id, Integer.optional # optional, for database testing
      attribute :video_id, Strict::String
      attribute :channel_id, Strict::String
      attribute :title, Strict::String
      attribute :description, Strict::String.optional
      attribute :default_thumbnail_url, Strict::String.optional

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
