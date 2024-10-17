# frozen_string_literal: true

module Outline
  module Youtube
    # Video mapper: Youtube repo -> Video entity
    class VideoMapper
      def initialize(yt_key, gateway_class)
        @api_key = yt_key
        @gateway_class = gateway_class
        @gateway = gateway_class.new(@api_key)
      end

      def find(id, title)
        data = @gateway.video_data(id, title)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @token, @gateway_class).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, token, gateway_class)
          @data = data
          @token = token
          @gateway_class = gateway_class
        end

        def build_entity
          Outline::Entity::Video.new(
            title: title,
            published_at: publishedAt,
            description: description,
            thumbnail_url: thumbnail_url,
            tags: tags
          )
        end

        def title
          @video_info['title']
        end

        def published_at
          @video_info['publishedAt']
        end

        def description
          @video_info['description']
        end

        def thumbnail_url
          @video_info['thumbnails']['high']['url']
        end

        def tags
          @video_info['tags']
        end
      end
    end
  end
end
