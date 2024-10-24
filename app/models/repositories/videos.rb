module Outline
  module Repository
    class Videos
      def self.find_id(id)
        rebuild_entity Database::VideoOrm.first(id: id)
      end

      def self.find_title(title)
        rebuild_entity Database::VideoOrm.first(title: title)
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

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Videos.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::VideoOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
