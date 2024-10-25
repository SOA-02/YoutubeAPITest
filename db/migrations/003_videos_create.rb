# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :video_id
      foreign_key :channel_id, :channels

      String :video_title, null: false
      String :video_description
      String :video_thumbnail_url
      String :video_tags

      DateTime :video_published_at
    end
  end
end
