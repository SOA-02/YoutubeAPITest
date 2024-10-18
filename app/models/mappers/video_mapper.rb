# frozen_string_literal: true

module Outline
  module Youtube
    # Video mapper
    class VideoMapper
      def initialize(yt_key, gateway_class)
        @api_key = yt_key
        @gateway = gateway_class.new(@api_key)
      end

      def find(title, id); end
    end
  end
end
