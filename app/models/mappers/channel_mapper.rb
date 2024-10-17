module CodePraise
  module Youtube
    class ChannelMapper
      def initialize(api_key, gateway_class = Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def find(video_id)
        video_data = @gateway.channel_data(video_id)
        # 確認 `items` 是否有內容，並取得第一個項目
        item_data = video_data['items']&.first
        raise 'Video data is missing' unless item_data # 若資料為空則報錯

        build_entity(item_data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      class DataMapper
        def initialize(data)
          @data = data['snippet']
          raise 'Snippet data missing' unless @data # 若無 `snippet` 則報錯
        end

        def build_entity
          Entity::Channel.new(
            title:,
            published_at:,
            channel_title:,
            description:,
            thumbnail_url:,
            tags:
          )
        end

        private

        def title
          @data['title']
        end

        def published_at
          @data['publishedAt']
        end

        def channel_title
          @data['channelTitle']
        end

        def description
          @data['description']
        end

        def thumbnail_url
          @data['thumbnails']['high']['url']
        end

        def tags
          @data['tags']
        end
      end
    end
  end
end
