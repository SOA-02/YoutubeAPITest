# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'
require 'fileutils'
require 'securerandom'

config = YAML.load_file(File.expand_path('../../config/secrets.yml', __dir__))

def channel_api_path(video_id, api_key)
  "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=#{video_id}&key=#{api_key}"
end

def video_api_path(video_id, api_key)
  "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{api_key}&part=snippet"
end

def fetch_video_data(url)
  response = HTTP.headers('Accept' => 'application/json').get(url)
  return handle_error(response) unless response.status.success?

  response.parse(:json)
end

def handle_error(response)
  puts "request_error: #{response.status}"
  nil
end

def ensure_directory_exists(path); end

def extract_channel_info(data)
  items = data['items']

  snippet = items.first['snippet']
  {
    channel_title: snippet['channelTitle'],
    channel_id: snippet['channelId']
  }
end

def extract_video_info(data)
  items = data['items']

  snippet = items.first['snippet']
  {
    title: snippet['title'],
    published_at: snippet['publishedAt'],
    description: snippet['description'],
    thumbnail_url: snippet['thumbnails']['high']['url'],
    tags: snippet['tags']
  }
end

def generate_unique_filename(dir); end

def save_video_info_as_yaml(video_info)
  file_path = File.expand_path('../../../spec/fixtures/video_info_fifi.yml', __dir__)
  write_to_file(file_path, video_info)
end

def write_to_file(file_path, video_info)
  File.write(file_path, video_info.to_yaml)
  puts "Video info saved to #{file_path}"
end

# Example Usage for video
video_id = 'jeqH4eMGjhY'
api_key = config['API_KEY']
url = video_api_path(video_id, api_key)

puts fetch_video_data(url)

begin
  data = fetch_video_data(url)
  video_info = extract_video_info(data)
  save_video_info_as_yaml(video_info)
end
