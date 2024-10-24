# frozen_string_literal: true

module Outline
  module Database
    # Object Relational Mapper for Video Entities
    class VideoOrm < Sequel::Model(:projects)
      many_to_one :id

      plugin :timestamps, update_on_create: true
    end
  end
end
