module Outline
  module Repository
    # Repository for Channels
    class Channels
      def self.all
        Database::ChannelOrm.all.map { |db_channel| rebuild_entity(db_channel) }
      end

      def self.find_channel_id(origin_id)
        rebuild_entity(Database::ChannelOrm.first(origin_id:))
      end

      def self.find(id)
        db_channel = Database::ChannelOrm[id]
        rebuild_entity(db_channel)
      end

      def self.create_or_update(entity)
        # 檢查 origin_id 是否已存在
        db_channel = Database::ChannelOrm.first(origin_id: entity.origin_id)

        if db_channel
          # 如果存在，更新現有的 channel
          db_channel.update(entity.to_attr_hash)
          rebuild_entity(db_channel)
        else
          # 如果不存在，創建新的 channel
          db_channel = PersistChannel.new(entity).call
          rebuild_entity(db_channel)
        end
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Channel.new(
          id: db_record.id,
          origin_id: db_record.origin_id,
          channel_title: db_record.channel_title,
          description: db_record.description,
          custom_url: db_record.custom_url,
          country: db_record.country,
          localized_title: db_record.localized_title,
          localized_description: db_record.localized_description,
          subscriber_count: db_record.subscriber_count,
          video_count: db_record.video_count,
          view_count: db_record.view_count
        )
      end
    end

    class PersistChannel
      def initialize(entity)
        @entity = entity
      end

      def call
        Database::ChannelOrm.create(@entity.to_attr_hash)
      end
    end
  end
end
