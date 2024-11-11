# frozen_string_literal: true
require 'dry/monads'

module Outline
  module Service
    # logic of fetching viewed videos
    class FetchViewedVideos
      include Dry::Monads::Result::Mixin
    
      def call(videos_list)

        videos = Repository::For.klass(Entity::Video).find_all_video(videos_list)

        Success(videos)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end