# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:playlists) do
      primary_key :id
      foreign_key :channel_id, :channels
      String      :playlist_id, unique: true
      String      :playlist_title, null: false
      String      :playlist_description
      String      :playlist_thumbnail_url
      DateTime :published_at
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
