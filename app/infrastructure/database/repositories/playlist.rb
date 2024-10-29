# frozen_string_literal: true

module Outline
  module Repository
    # Repository for Playlists
    class Playlists
      def self.all
        Database::PlaylistOrm.all.map { |db_playlist| rebuild_entity(db_playlist) }
      end

      def self.find_playlist_id(playlist_id)
        rebuild_entity(Database::PlaylistOrm.first(playlist_id:))
      end

      def self.find(id)
        db_playlist = Database::PlaylistOrm[id]
        rebuild_entity(db_playlist)
      end

      def self.create_or_update(entity)
        # 檢查 origin_id 是否已存在
        db_playlist = Database::PlaylistOrm.first(playlist_id: entity.playlist_id)

        if db_playlist
          # 如果存在，更新現有的 channel
          db_playlist.update(entity.to_attr_hash)
        else
          # 如果不存在，創建新的 channel
          db_playlist = PersistChannel.new(entity).call
        end
        rebuild_entity(db_playlist)
      end

      def self.rebuild_entity(db_playlist_record) # rubocop:disable Metrics/MethodLength
        return nil unless db_playlist_record

        Entity::Playlist.new(
          id: db_playlist_record.id,
          playlist_title: db_playlist_record.channel_title,
          description: db_playlist_record.description,
          custom_url: db_playlist_record.custom_url,
          country: db_playlist_record.country,
          localized_title: db_playlist_record.localized_title,
          localized_description: db_playlist_record.localized_description,
          subscriber_count: db_playlist_record.subscriber_count,
          video_count: db_playlist_record.video_count,
          view_count: db_playlist_record.view_count
        )
      end
    end

    class PersistChannel # rubocop:disable Style/Documentation
      def initialize(entity)
        @entity = entity
      end

      def call
        Database::PlaylistOrm.create(@entity.to_attr_hash)
      end
    end
  end
end