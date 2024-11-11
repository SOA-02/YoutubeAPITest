# frozen_string_literal: true

require 'dry/transaction'
require 'logger'

module Outline
  module Service
    # Transaction to store video from Youtube API to database
    class AddVideo
      MSG_VID_NOT_FOUND = 'Could not find that Youtube video'
      MSG_VIDINFO_NOT_FOUND = 'Sorry, could not find that video information.'
      include Dry::Transaction

      step :find_video
      step :store_video

      private

      # Logger instance for better error tracking
      LOGGER = Logger.new($stdout)
      def find_video(video_id)
        video_info = {}
        video = video_in_database(video_id)
        if video
          video_info[:local_video] = video
        else
          video_info[:remote_video] = video_from_youtube(video_id)
        end
        Success(video_info)
      rescue StandardError => e
        LOGGER.error("Error in find_video: #{e.message}")
        Failure(e.message)
      end

      def store_video(video_info)
        if video_info[:remote_video]
          new_video = video_info[:remote_video]
          video_info[:local_video] = Repository::For.entity(new_video).create(new_video)
        end
        Success(video_info)
      rescue StandardError => e
        LOGGER.error("Error in store_video: Having trouble accessing the database - #{e.message}")
        Failure(MSG_VIDINFO_NOT_FOUND)
      end

      # Support methods for fetching video data

      def video_from_youtube(input)
        Youtube::VideoMapper.new(App.config.API_KEY).find(input)
      rescue StandardError => e
        LOGGER.error("Error in video_from_youtube: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_VID_NOT_FOUND)
      end

      def video_in_database(input)
        Repository::For.klass(Entity::Video).find_id(input)
      end
    end
  end
end
