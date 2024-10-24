# frozen_string_literal: true

module Outline
  module Database
    # Object Relational Mapper for Video Entities
    class ChannelOrm < Sequel::Model(:videos)
      one_to_many :videos, class: :'Outline::Database::VideoOrm', key: :channel_id

      plugin :timestamps, update_on_create: true
    end
  end
end
