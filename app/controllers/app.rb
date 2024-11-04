# frozen_string_literal: true

require 'rack' # for Rack::MethodOverride
require 'roda'
require 'slim'

module Outline
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # Load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []
        # Load previously viewed projects
        video = Repository::For.klass(Entity::Video).all
        
        session[:watching] = video.map(&:video_id)


        view 'home', locals: { video: }
      end

      routing.on 'search' do
        routing.is do
          # POST /search/
          routing.post do
            key_word = routing.params['search_key_word']
            routing.halt(400, 'Search keyword parameter is required') unless key_word
            routing.redirect "search/#{key_word}"
          end
        end

        routing.on String do |key_word|
          # GET /search/key_word
          routing.get do
            @search_results = Youtube::SearchMapper
              .new(App.config.API_KEY).find(key_word)
            view 'search', locals: { search_results: @search_results }
          rescue StandardError => e
            puts "Error: #{e.message} at #{e.backtrace.first}" # Output to console
            view 'error', locals: { error_message: e.message }
          end
        end
      end
      routing.on 'outline' do
        routing.is do
          routing.post do
            # yt_url = routing.params['youtube_url']
            # routing.halt(400, 'YouTube channel URL parameter is required') unless yt_url

            # routing.halt(400, 'Invalid YouTube URL') unless (yt_url.include? 'youtube.com') &&
            #                                                 (yt_url.include? 'watch?v=')
            # video_id = yt_url[/(?<=v=)[\w-]+/]
            # binding.irb
            video = Youtube::VideoMapper
              .new(App.config.API_KEY).find(video_id)
            Repository::For.entity(video).create(video)
            routing.redirect "outline/#{video_id}"
          end
        end

        routing.on String do |video_id|
          # DELETE /outline/{video_id}
          routing.delete do
            session[:watching].delete(video_id)
            binding.irb
            routing.redirect '/'
          end

          # GET /outline/video_id
          routing.get do
            # puts "Video_id#{video_id}"
            video = Youtube::VideoMapper
              .new(App.config.API_KEY).find(video_id)
            # puts "Get video=>#{video.inspect}"
            Repository::For.entity(video).create(video)
            # Add new project to watched set in cookies
            session[:watching].insert(0, video.video_id).uniq!
            binding.irb
            video = Repository::For.klass(Entity::Video).find_id(video_id)
            # puts "Retrieved video: #{video.inspect}"
            view 'outline', locals: { video: video }
          rescue StandardError => e
            puts "Error: #{e.message} at #{e.backtrace.first}" # Output to console
            view 'error', locals: { error_message: e.message }
          end
        end
      end
      routing.on 'channel' do
        routing.is do
          # POST /channel/
          routing.post do
            yt_url = routing.params['youtube_url']
            routing.halt(400, 'YouTube channel URL parameter is required') unless yt_url

            routing.halt(400, 'Invalid YouTube URL') unless (yt_url.include? 'googleapis.com') &&
                                                            (yt_url.include? '/channels/') &&
                                                            (yt_url.split('/').count >= 5)
            channel_id = yt_url.split('/').last

            channel = Youtube::ChannelMapper
              .new(App.config.API_KEY).find(channel_id)
            Repository::For.entity(channel).create_or_update(channel)
            routing.redirect "channel/#{channel_id}"
          end
        end

        routing.on String do |channel_id|
          # GET /channel/channel_id
          routing.get do
            channel = Repository::For.klass(Entity::Channel).find_channel_id(channel_id)
            view 'channel', locals: { channel: channel }
          end
        end
      end
    end
  end
end
