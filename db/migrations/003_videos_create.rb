# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :id
      foreign_key :channel_id, :channels

      String :video_id, unique: true
      String :video_title
      String :video_description
      String :video_thumbnail_url
      String :video_published_at

      DateTime :created_at
      DateTime :updated_at
      index :video_id
    end
  end
end
