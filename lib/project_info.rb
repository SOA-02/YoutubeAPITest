# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'
require 'fileutils'
require 'securerandom'

config = YAML.safe_load_file(File.expand_path('../config/secrets.yml', __dir__))

def youtube_api_path(video_id, api_key)
  "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{api_key}&part=snippet"
end

# Handling HTTP requests and errors
class YoutubeApiClient
  def self.fetch_data(url)
    response = HTTP.headers('Accept' => 'application/json').get(url)
    return handle_error(response) unless response.status.success?

    response.parse(:json)
  end

  def self.handle_error(response)
    puts "request_error: #{response.status}"
    nil
  end
end

# Handling YouTube data and file operations
module YoutubeUtil
  def self.ensure_directory_exists(path)
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
  end

  def self.extract_video_info(data)
    items = data['items']
    return unless data && items && !items.empty?

    snippet = items.first['snippet']
    {
      title: snippet['title'],
      published_at: snippet['publishedAt'],
      channel_title: snippet['channelTitle'],
      description: snippet['description'],
      thumbnail_url: snippet['thumbnails']['high']['url']
    }
  end

  def self.generate_unique_filename(dir)
    "#{dir}youtube_channel_info.yml"
  end
end

def save_video_info_as_yaml(video_info)
  return puts 'Unable to find video data.' unless video_info

  file_path = '../spec/fixtures/youtube_channel_info.yml'
  YoutubeUtil.ensure_directory_exists(File.dirname(file_path))

  write_to_file(file_path, video_info)
end

def write_to_file(file_path, video_info)
  File.write(file_path, video_info.to_yaml)
  puts "Video information saved to #{file_path}"
end

# main logic
video_id = 'jeqH4eMGjhY'
api_key = config['API_KEY']
url = youtube_api_path(video_id, api_key)

begin
  data = YoutubeApiClient.fetch_data(url)
  video_info = YoutubeUtil.extract_video_info(data)
  save_video_info_as_yaml(video_info)
rescue JSON::ParserError => e
  puts "JSON parsing error: #{e.message}"
end
