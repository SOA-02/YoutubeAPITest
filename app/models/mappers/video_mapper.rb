# frozen_string_literal: true

require 'yaml'
require_relative '../gateways/youtube_api'
require_relative '../entities/video'

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
        item_data = video_data['items'].first
        build_entity(item_data)
      end

      def build_entity(items_data)
        DataMapper.new(items_data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(items_data)
          @items_data = items_data['snippet']
        end

        def build_entity
          Outline::Entity::Video.new(
            video_id: id,
            video_title: title,
            video_published_at: published_at,
            video_description: description,
            video_thumbnail_url: thumbnail_url,
            video_tags: tags
          )
        end

        private

        def id
          @items_data['id']
        end

        def title
          @items_data['title']
        end

        def published_at
          @items_data['publishedAt']
        end

        def description
          @items_data['description']
        end

        def thumbnail_url
          @items_data['thumbnails']['high']['url']
        end

        def tags
          @items_data['tags']
        end
      end
    end
  end
end
