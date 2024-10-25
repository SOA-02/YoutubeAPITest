# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:playlists) do
      primary_key :id

      foreign_key :channel_id, :channels
      String :playlist_title, null: false
      String :playlist_description

      DateTime :published_at
    end
  end
end
