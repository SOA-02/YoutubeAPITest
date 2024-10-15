# frozen_string_literal: true

require 'http'
require_relative 'basic_channel_info'
require 'yaml'

config_path = File.join(File.dirname(__dir__), 'config', 'secrets.yml')
config = YAML.safe_load_file(config_path)
config['API_KEY']

module CodePraise
  # Represents interactions with the YouTube API.
  class YoutubeApi
    # Your class implementation...
    API_PROJECT_ROOT = 'https://www.googleapis.com/youtube/v3'
    module Errors
      # Represents an error that occurs when a YouTube channel cannot be found.
      class ChannelNotFound < StandardError; end
    end
    HTTP_ERROR = {
      404 => Errors::ChannelNotFound
    }.freeze

    def initialize(token)
      @yt_token = token
    end

    def basic_channel_info(video_id)
      url = yt_api_path(video_id, @yt_token)
      basic_channel_info_data = call_yt_url(url).parse
      basic_channel_info_data['items'].map do |data|
        CodePraise::ChannelInfo.new(data)
      end
    end

    private

    def yt_api_path(video_id, api_key)
      "#{API_PROJECT_ROOT}/videos?id=#{video_id}&key=#{api_key}&part=snippet"
    end

    def call_yt_url(url)
      result = CodePraise::YoutubeApiUtils.make_http_request(url)
      handle_response(result)
    end

    # def make_http_request(url)
    #   HTTP.headers('Accept' => 'application/json').get(url)
    # end

    def handle_response(result)
      code = result.code
      puts "HTTP Response Code: #{code}."
      puts "Response Body: #{result}" # 印出回傳的內容
      raise(HTTP_ERROR[code]) unless YoutubeApiUtils.successful_or_not(result)

      result
    end
  end

  # This module provides utility methods for interacting with the
  # YouTube API, such as checking the success of API responses.
  module YoutubeApiUtils
    def self.make_http_request(url)
      HTTP.headers('Accept' => 'application/json').get(url)
    end

    def self.successful_or_not(result)
      !CodePraise::YoutubeApi::HTTP_ERROR.keys.include?(result.code)
    end
  end
end
