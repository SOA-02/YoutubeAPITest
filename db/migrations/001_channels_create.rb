# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:channels) do
      primary_key :channel_id

      String :channel_title, null: false
      String :description

      DateTime :published_at
    end
  end
end
