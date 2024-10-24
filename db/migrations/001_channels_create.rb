# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:channels) do
      primary_key :id

      String :channel_id, unique: true, null: false
      String :channel_title, null: false
      String :description

      DateTime :published_at
    end
  end
end
