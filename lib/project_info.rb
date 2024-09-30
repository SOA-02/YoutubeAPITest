# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'

config = YAML.safe_load_file('../config/secrets.yml')

def youtube_api_path(video_id, api_key)
  "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{api_key}&part=snippet"
end

def fetch_youtube_data(url)
  response = HTTP.headers('Accept' => 'application/json').get(url)
  return handle_request_error(response) unless response.status.success?

  response.parse(:json)
end

def handle_request_error(response)
  puts "request_error: #{response.status}"
  nil
end

def extract_video_info(data)
  return unless data && data['items'] && !data['items'].empty?

  snippet = data['items'].first['snippet']
  {
    title: snippet['title'],
    published_at: snippet['publishedAt'],
    channel_title: snippet['channelTitle'],
    description: snippet['description'],
    thumbnail_url: snippet['thumbnails']['high']['url']
  }
end

def display_video_info(video_info)
  return puts 'Unable to find video data.' unless video_info

  video_info.each { |key, value| puts "#{key}: #{value}" }
end

video_id = 'jeqH4eMGjhY'
api_key = config['API_KEY']
url = youtube_api_path(video_id, api_key)

begin
  data = fetch_youtube_data(url)
  video_info = extract_video_info(data)
  display_video_info(video_info)
rescue JSON::ParserError => e
  puts "JSON parsing error: #{e.message}"
end
