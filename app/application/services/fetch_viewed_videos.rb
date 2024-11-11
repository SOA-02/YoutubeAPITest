# frozen_string_literal: true

module Service
  # logic of fetching viewed videos
  class FetchViewedVideos
    def call(watching)
      videos = Repository::For.klass(Entity::Video).find_all_video(watching)
      return Failure('No videos found') if videos.empty?

      Success(videos)
    end
  end
end
