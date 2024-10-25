# frozen_string_literal: true

require 'sequel'

module Outline
  module Database
    # Object-Relational Mapper for Playlist
    class PlaylistOrm < Sequel::Model(:playlists)
      many_to_one :playlists_owner,
                  class: :'Outline::Database::PlaylistOrm',
                  key: :playlist_id
      plugin :timestamps, update_on_create: true
    end
  end
end
