# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :id

      foreign_key :channel_id, :channels
      String :title, null: false
      String :description
      String :thumbnail_url
      String :tags

      DateTime :published_at
    end
  end
end
