# Class to handle playlist URL processing and extraction
module TitleTOC
  class Playlist
    def initialize(url)
      @url = url
    end

    def extract_playlist_id
      match = @url.match(/[&?]list=([^&]+)/)
      match[1] if match
    end
  end

