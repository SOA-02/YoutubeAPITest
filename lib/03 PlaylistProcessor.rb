# Main class to manage the entire process

require 'YouTubeAPI'
require 'Playlist'
require 'FileWriter'

module TitleTOC
  class PlaylistProcessor
    def initialize(url, output_filename = 'spec/fixtures/TitleTOC_results.txt')
      @url = url
      @output_filename = output_filename
      @api = YouTubeAPI.new
    end

    def process
      playlist_id = Playlist.new(@url).extract_playlist_id
      unless playlist_id
        puts 'Invalid playlist URL.'
        return
      end

      playlist_info = @api.fetch_playlist_info(playlist_id)
      FileWriter.new(@output_filename).write_playlist_info(playlist_info)
    end
  end

  
