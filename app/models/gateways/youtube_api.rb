# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'
require_relative '../entities/video_info06_fifi'

config = YAML.load_file(File.expand_path('../../../config/secrets.yml', __dir__))

module Outline
  module Youtube
    # Library for Youtube Web API
    class YoutubeApi
      YT_API_ROOT = 'https://www.googleapis.com/youtube/v3'

      module Errors
        class VideoNotFound < StandardError; end
        class Unauthorized < StandardError; end
      end

      HTTP_ERROR = {
        401 => Errors::Unauthorized,
        404 => Errors::VideoNotFound
      }.freeze

      def initialize(token)
        @yt_token = token
      end

      def video_info(video_id)
        video_req_url = yt_video_path(video_id, @yt_token)
        video_data = call_yt_url(video_req_url).parse

        video_item = video_data['items'].first
        Outline::Video.new(video_item, self)
      end

      def playlist_info(playlist_id)
        # playlist_req_url = yt_playlist_path(playlist_id, @yt_token)
        # playlist_data = call_yt_url(playlist_req_url).parse
      end

      def yt_video_path(video_id, api_key)
        "#{YT_API_ROOT}/videos?id=#{video_id}&key=#{api_key}&part=snippet"
      end

      def yt_playlist_path(playlist_id, api_key)
        "#{YT_API_ROOT}/playlists?id=#{playlist_id}&key=#{api_key}&part=snippet"
      end

      def call_yt_url(url)
        result = HTTP.headers('Accept' => 'application/json').get(url)
        successful?(result) ? result : raise(HTTP_ERROR[result.code])
      end

      def successful?(result)
        !HTTP_ERROR.keys.include?(result.code)
      end
    end
  end
end

# Example Usage
api_key = config['API_KEY']
video_id = 'jeqH4eMGjhY'
playlist_id = ''

begin
  youtube_api = Outline::YoutubeApi.new(api_key)
  video_info = youtube_api.video_info(video_id)
  puts "Video Title: #{video_info.title}"
  puts "Published At: #{video_info.published_at}"
  puts "Description: #{video_info.description}"
  puts "Thumbnail URL: #{video_info.thumbnail_url}"
end
