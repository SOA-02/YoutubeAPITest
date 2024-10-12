# Main script
require 'google/apis/youtube_v3'
require 'json'
require 'PlaylistProcessor'


puts "Enter the YouTube playlist URL:"
playlist_url = gets.chomp

processor = PlaylistProcessor.new(playlist_url)
processor.process
