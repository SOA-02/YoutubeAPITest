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

        item_data = data['items']

        return 'Video data is missing' if item_data.nil? || item_data.empty? 


        video_items = item_data.select { |item| item['id']['kind'] == 'youtube#video' }
        return 'No video items found' if video_items.empty?

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
