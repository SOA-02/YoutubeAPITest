# Main script
require 'json'
require_relative '03_PlaylistProcessor'
puts "loaded successfully"


puts "Enter the YouTube playlist URL:"
playlist_url = gets.chomp

processor = TitleTOC::PlaylistProcessor.new(playlist_url)
processor.process