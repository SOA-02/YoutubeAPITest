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
      result =
        HTTP.headers('Accept' => 'application/json')
            .get(url)
      code = result.code
      puts "HTTP Response Code: #{code}."
      puts "Response Body: #{result.to_s}" # 印出回傳的內容
      successful_or_not(result) ? result : raise(HTTP_ERROR[code])
    end

    def successful_or_not(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end