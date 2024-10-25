# frozen_string_literal: true

module Outline
  module Youtube
    class PlaylistMapper # rubocop:disable Style/Documentation
      def initialize(api_key, gateway_class = YouTubeApi)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = gateway_class.new(@api_key)
      end

      def find(playlist_id)
        playlist_info = @gateway.playlist_info(playlist_id)
        item_data = playlist_info['items']&.first
        raise 'Playlist data is missing' unless item_data

        build_entity(item_data)
      end

      def build_entity(data)
        Datamapper.new(data).build_entity
      end

      class Datamapper # rubocop:disable Style/Documentation
        def initialize(data)
          @data = data
          raise 'Snippet data missing' unless data
        end

        def build_entity
          Entity::Playlist.new(
            playlist_id: id,
            playlist_title: title,
            playlist_published_at: published_at,
            playlist_description: description,
            playlist_thumbnail_url: thumbnail_url,
            playlist_item_count: item_count
          )
        end

        private

        def playlist_id
          @items_data['id']
        end

        def playlist_title
          @items_data['snippet']['title']
        end

        def playlist_published_at
          @items_data['snippet']['publishedAt']
        end

        def playlist_description
          @items_data['snippet']['description']
        end

        def playlist_thumbnail_url
          @items_data['snippet']['thumbnails']['high']['url']
        end
      end
    end
  end
end
