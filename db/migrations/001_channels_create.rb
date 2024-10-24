# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:channels) do
      primary_key :id

      String      :origin_id, unique: true
      String      :channel_title, null: false
      String      :description
      String      :custom_url
      String      :country
      String      :localized_title
      String      :localized_description
      Integer :subscriber_count
      Integer :video_count
      Integer :view_count

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
