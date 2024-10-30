# frozen_string_literal: true

module Outline
  module Youtube
    class PlaylistMapper # rubocop:disable Style/Documentation
      def initialize(api_key, gateway_class = Outline::Youtube::YoutubeApi)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = gateway_class.new(@api_key)
      end

      # def load_several(url)
      #   @gateway.playlist_data(url).map do |data|
      #     PlaylistMapper.build_entity(data)
      #   end
      # end

      def find(playlist_id)
        data = @gateway.playlist_data(playlist_id)
        # puts "Playlist Item data here: #{data}"
        # raise 'Playlist data is missing' unless data
        build_entity(data)
      end

      def build_entity(data)
        Datamapper.new(data).build_entity
        # puts "Entity exist: #{@entity}"
        # raise 'Entity missing' unless @entity
      end

      class Datamapper # rubocop:disable Style/Documentation
        def initialize(data)
          @mapper_data = data
          # puts "items_data here #{@items_data}"
        end

        def build_entity
          Outline::Entity::Playlist.new(
            id: nil,
            playlist_id:,
            playlist_title:,
            playlist_published_at:,
            playlist_description:,
            playlist_thumbnail_url:
          )
        end

        private

        def playlist_id
          # @items_data.dig('items', 'id').to_s 
          @mapper_data['items'][0]['id']
        end

        def playlist_title
          # @items_data.dig('items', 'snippet', 'title') 
          @mapper_data['items'][0]['snippet']['title'] 
        end

        def playlist_published_at
          # @items_data.dig('items', 'snippet', 'publishedAt') 
          @mapper_data['items'][0]['snippet']['publishedAt'] 
        end

        def playlist_description
          # @items_data.dig('items', 'snippet', 'description') 
          @mapper_data['items'][0]['snippet']['description'] 
        end

        def playlist_thumbnail_url
          # @items_data.dig('items', 'snippet', 'thumbnails') 
          @mapper_data['items'][0]['snippet']['thumbnails']['high']['url'] 
        end
      end
    end
  end
end
