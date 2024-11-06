# frozen_string_literal: true

require 'sequel'

module Outline
  module Database
    # Object Relational Mapper for Video Entities
    class VideoOrm < Sequel::Model(:videos)
      many_to_one :channel,
                  class: :'Outline::Database::ChannelOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
