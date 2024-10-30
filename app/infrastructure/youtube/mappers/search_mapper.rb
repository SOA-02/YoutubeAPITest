# frozen_string_literal: true

module Outline
  # Provides access to contributor data
  module Youtube
    # Data Mapper: Youtube contributor -> Search entity
    class SearchMapper
      def initialize(api_key, gateway_class = YoutubeApi)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def load_several(url)
        @gateway.search_info(url).map do |data|
          self.class.build_entity(data)
        end
      end

      def find(key_word)
        data = @gateway.search_info(key_word)
        # 確認 `items` 是否有內容，並取得第一個項目
        item_data = data['items']
        # puts "Item data: #{item_data}"
        raise 'Video data is missing' if item_data.nil? || item_data.empty? # 若資料為空則報錯

        # 只選擇 id.kind 為 'youtube#video' 的項目
        video_items = item_data.select { |item| item['id']['kind'] == 'youtube#video' }
        raise 'No video items found' if video_items.empty? # 若沒有視頻項目則報錯

        video_items.map do |item|
          build_entity(item)

        end
      end
      
      def build_entity(data)
        # puts "=== data===: #{data.inspect}"
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
          raise 'Snippet data missing' unless @data # 若無 `snippet` 則報錯
        end

        def build_entity
          Entity::Search.new(
            id: nil,
            video_id:,
            channel_id:,
            title:,
            description:,
            default_thumbnail_url:
          )
        end

        private

        def video_id
          # @data['id']['videoId']
          # puts "AAA=>#{@data['id']['videoId']}"
          @data['id']['videoId']
        end

        def channel_id
          @data['snippet']['channelId']
        end

        def title
          @data['snippet']['title']
        end

        def description
          @data['snippet']['description']
        end

        def default_thumbnail_url
          @data['snippet']['thumbnails']['default']['url']
        end
      end
    end
  end
end
