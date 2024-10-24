# frozen_string_literal: true

require 'sequel'

module Outline
  module Database
    # Object Relational Mapper for Video Entities
    class VideoOrm < Sequel::Model(:videos)
      many_to_one :channel,
                  class: :'Outline::Database::ChannelOrm',
                  key: :channel_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(video_info)
        first(video_id: video_info[:video_id]) || create(video_info)
      end
    end
  end
end
