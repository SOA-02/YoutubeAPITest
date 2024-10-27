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

      def self.create(entity)
        raise 'Video already exists' if find(entity)
        
        db_video = Outline::Database::VideoOrm.first(video_id: entity.video_id)
        record = Outline::Database::VideoOrm.create(entity.to_attr_hash)

        puts record.video_id
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

        def call; end
      end
    end
  end
end
