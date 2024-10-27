# frozen_string_literal: true

require 'sequel'

module Outline
  module Database
    # Object-Relational Mapper for Channels
    class ChannelOrm < Sequel::Model(:channels)
      # one_to_many :owned_projects,
      #             class: :'Outline::Database::ProjectOrm',
      #             key: :owner_id
      plugin :timestamps, update_on_create: true
    end
  end
end
