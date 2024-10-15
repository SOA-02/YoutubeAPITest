# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/playlist_processor'

describe 'Tests YouTube Playlist API and File Writing' do
  before do
    @playlist_url = CORRECT['playlist_url']
    @invalid_playlist_url = CORRECT['invalid_playlist_url']
    @processor = TitleTOC::PlaylistProcessor.new(@playlist_url, 'spec/fixtures/test_output.txt')
    @invalid_processor = TitleTOC::PlaylistProcessor.new(@invalid_playlist_url)
  end

  describe 'Playlist information fetching' do
    it 'HAPPY: should fetch correct playlist title and video titles' do
      playlist_info = @processor.process
      _(playlist_info[:playlist_title]).must_equal CORRECT['playlist_title']
      _(playlist_info[:video_titles]).must_equal CORRECT['video_titles']
    end

    it 'SAD: should return nil for invalid playlist URL' do
      _(proc { @invalid_processor.process }).must_output(/Invalid playlist URL/)
    end
  end

  describe 'File writing' do
    before do
      @file_writer = FileWriter.new('spec/fixtures/test_output.txt')
    end

    it 'HAPPY: should write playlist info to file correctly' do
      playlist_info = {
        playlist_title: CORRECT['playlist_title'],
        video_titles: CORRECT['video_titles']
      }
      @file_writer.write_playlist_info(playlist_info)

      output_content = File.read('spec/fixtures/test_output.txt')
      correct_content = File.read('spec/fixtures/correct_output.txt')

      _(output_content).must_equal correct_content
    end
  end
end
