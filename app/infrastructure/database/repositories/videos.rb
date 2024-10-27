# frozen_string_literal: true

module Outline
  module Repository
    # Repository for Videos
    class Videos
      def self.all
        Database::VideoOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find(entity)
        find_id(entity.video_id)
      end

      def self.find_id(id)
        db_record = Database::VideoOrm.first(video_id: id)
        rebuild_entity(db_record)
      end

      def self.find_title(title)
        db_record = Database::VideoOrm.first(video_title: title)
        rebuild_entity(db_record)
      end

      def self.db_find_or_create(entity)
        # raise 'Video already exists' if find(entity)
        # rebuild_entity(db_video)
      end

      def self.create(entity)
        db_channel = Database::VideoOrm.first(video_id: entity.video_id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Video.new(
          id: db_record.id,
          video_id: db_record.video_id,
          video_title: db_record.video_title,
          video_published_at: db_record.video_published_at,
          video_description: db_record.video_description,
          video_thumbnail_url: db_record.video_thumbnail_url,
          video_tags: db_record.video_tags
        )
      end

      # Helper class to persist video to database
      class PersistVideo
        def initialize(entity)
          @entity = entity
        end

        def call
          channel = Channels.create_or_update(@entity.channel)

          create_video.tap do |db_video|
            db_video.update(channel_id: channel.id)
          end
        end
      end
    end
  end
end
