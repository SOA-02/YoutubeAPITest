# frozen_string_literal: true

module Outline
  module Repository
    # Repository for Videos
    class Videos
      def self.all
        Database::VideoOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find(entity)
        find_id(entity.id)
      end

      def self.find_id(id)
        db_record = Database::VideoOrm.first(id:)
        rebuild_entity(db_record)
      end

      def self.find_title(title)
        db_record = Database::VideoOrm.first(title:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Video already exists' if find(entity)


      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Video.new(
          id: db_record.id,
          title: db_record.title,
          published_at: db_record.published_at,
          description: db_record.description,
          thumbnail_url: db_record.thumbnail_url,
          tags: db_record.tags
        )
      end
    end
  end
end
