# Class to handle file writing operations
require 'YouTubeAPI'
require 'Playlist'

module TitleTOC
  class FileWriter
    def initialize(filename)
      @filename = filename
    end

    def write_playlist_info(playlist_info)
      content = "# #{playlist_info[:playlist_title]}\n"
      playlist_info[:video_titles].each do |video_title|
        content += "## #{video_title}\n"
      end

      # Use File.write to directly write the entire content to the file
      File.write(@filename, content)
      puts "Titles written to #{@filename}"
    end
  end
