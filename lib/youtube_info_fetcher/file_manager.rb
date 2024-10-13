# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'securerandom'

module YouTubeInfoFetcher
  class FileManager
    def save_video_info(video_info)
      return puts 'Unable to find video data.' unless video_info

      dir = '../spec/fixtures/' # Fixed directory
      ensure_directory_exists(dir)

      file_path = generate_unique_filename(dir)
      File.write(file_path, video_info.to_yaml)
      puts "Video information saved to #{file_path}"
    end

    private

    def ensure_directory_exists(path)
      FileUtils.mkdir_p(path) unless File.directory?(path)
    end

    def generate_unique_filename(dir, prefix = 'github_results_', ext = '.yml')
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      random_str = SecureRandom.hex(4)
      "#{dir}/#{prefix}#{timestamp}_#{random_str}#{ext}"
    end
  end
end
