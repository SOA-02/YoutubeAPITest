# frozen_string_literal: true

module Outline
  # Provides access to contributor data
  module Youtube
    # Data Mapper: Youtube contributor -> Channel entity
    class ChannelMapper
      def initialize(api_key, gateway_class = YoutubeApi)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def load_several(url)
        @gateway.channel_info(url).map do |data|
          ChannelMapper.build_entity(data)
        end
      end

      def find(channel_id)
        data = @gateway.channel_info(channel_id)

        item_data = data['items']&.first
        raise 'Video data is missing' unless item_data 

        ChannelMapper.build_entity(item_data)
      end

      # Changed build_entity to a class method
      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
          raise 'Snippet data missing' unless @data 
        end

        # rubocop:disable Metrics/MethodLength
        def build_entity
          Outline::Entity::Channel.new(
            id: nil,
            origin_id:,
            channel_title:,
            description:,
            custom_url:,
            country:,
            localized_title:,
            localized_description:,
            subscriber_count:,
            video_count:,
            view_count:
          )
        end
        # rubocop:enable Metrics/MethodLength

        private

        def origin_id
          @data['id']
        end

        def channel_title
          @data['snippet']['title']
        end

        def description
          @data['snippet']['description']
        end

        def custom_url
          @data['snippet']['customUrl']
        end

        def country
          @data['snippet']['country']
        end

        def localized_title
          @data.dig('snippet', 'localized', 'title') || @data['snippet']['title']
        end

        def localized_description
          @data.dig('snippet', 'localized', 'description') || @data['snippet']['description']
        end

        def subscriber_count
          @data['statistics']['subscriberCount'].to_i
        end

        def video_count
          @data['statistics']['videoCount'].to_i
        end

        def view_count
          @data['statistics']['viewCount'].to_i
        end
      end
    end
  end
end
