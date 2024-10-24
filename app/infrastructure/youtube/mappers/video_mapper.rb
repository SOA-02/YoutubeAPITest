# frozen_string_literal: true

module Outline
  module Youtube
    # Video mapper: Youtube repo -> Video entity
    class VideoMapper
      def initialize(yt_key, gateway_class = Outline::Youtube::YoutubeApi)
        @api_key = yt_key
        @gateway_class = gateway_class
        @gateway = gateway_class.new(@api_key)
      end

      def find(video_id)
        video_data = @gateway.video_info(video_id)
        build_entity(video_data)
      end

      def build_entity(video_data)
        DataMapper.new(video_data, @api_key, @gateway_class).build_entity_map
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(mapper_data, token, gateway)
          @mapper_data = mapper_data
          @token = token
          @gateway = gateway
        end

        def build_entity_map
          # value = @mapper_data['items'][0]['snippet']
          # puts "value being passed to Video.new: #{value.inspect}"
          # "value class: #{value.class}"

          Outline::Entity::Video.new(
            id: id,
            title: title,
            published_at: published_at,
            description: description,
            thumbnail_url: thumbnail_url,
            tags: tags
          )
        end

        private

        def id
          @mapper_data['items'][0]['id']
        end

        def title
          @mapper_data['items'][0]['snippet']['title']
        end

        def published_at
          @mapper_data['items'][0]['snippet']['publishedAt']
        end

        def description
          @mapper_data['items'][0]['snippet']['description']
        end

        def thumbnail_url
          @mapper_data['items'][0]['snippet']['thumbnails']['high']['url']
        end

        def tags
          @mapper_data['items'][0]['snippet']['tags']
        end
      end
    end
  end
end
