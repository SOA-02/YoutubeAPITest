# frozen_string_literal: true

require 'rack' # for Rack::MethodOverride
require 'roda'
require 'slim'
require 'slim/include'
module Outline
  # Web App
  class App < Roda
    js_files = [
      'jquery.min.js',
      'editormd.min.js',
      'lib/codemirror/codemirror.min.js',
      'lib/codemirror/addons.min.js',
      'lib/codemirror/modes.min.js',
      'lib/marked.min.js',
      'lib/prettify.min.js'
    ]
    css_files = [
      'editormd.css',
      'lib/codemirror/codemirror.min.css',
      'lib/codemirror/addon/dialog/dialog.css',
      'lib/codemirror/addon/search/matchesonscrollbar.css'
    ]
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets',
                    url: '/',
                    css: css_files,
                    js: js_files # 加载 js/lib 文件夹中的所有 JS 文件
    plugin :common_logger, $stderr

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    MSG_NO_VIDS = 'Please enter the keywords you are interested in to get started.'
    MSG_NO_EMPTY_VALUE = 'Please do not enter an empty value.'
    MSG_NO_RECLIST = 'Unable to recommend a list of related videos for you.'
    MSG_SERVER_ERROR = 'Internal Server Error'
    MSG_VID_NOT_FOUND = 'Could not find that Youtube video'
    MSG_VID_EXISTS = 'Videos already exists.'
    MSG_VIDINFO_NOT_FOUND = 'Sorry,Could not find that  video information.'

    route do |routing|
      routing.assets # Load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        # Get cookie viewer's previously seen videos
        session[:watching] ||= []
        # Load previously viewed videos
        video = Repository::For.klass(Entity::Video)
          .find_all_video(session[:watching])
        session[:watching] = video.map(&:video_id)
        flash.now[:notice] = MSG_NO_VIDS if session[:watching].none?
        viewable_videos = Views::VideosList.new(video)
        view 'home', locals: { videos: viewable_videos }
      end

      routing.on 'search' do
        routing.is do
          # POST /search/
          routing.post do
            key_word = routing.params['search_key_word']
            if key_word.nil? || key_word.strip.empty? || key_word !~ /\w/
              flash[:error] = MSG_NO_EMPTY_VALUE
              response.status = 400
              routing.redirect '/'
            else
              routing.redirect "search/#{key_word}"
            end
          end
        end

        routing.on String do |key_word|
          # GET /search/key_word
          routing.get do
            @search_results = Youtube::SearchMapper
              .new(App.config.API_KEY).find(key_word)
            if @search_results == 'No video items found'
              flash[:error] = MSG_NO_RECLIST
              routing.redirect '/'
            end
            view 'search', locals: { search_results: @search_results }
          rescue StandardError => err
            puts "Error: #{err.message} at #{err.backtrace.first}"
            flash[:error] = MSG_SERVER_ERROR
            routing.redirect '/'
          end
        end
      end
      routing.on 'outline' do
        routing.is do
          routing.post do
            routing.redirect "outline/#{video_id}"
          end
        end

        routing.on String do |video_id|
          # DELETE /outline/{video_id}
          routing.delete do
            session[:watching].delete(video_id)
            routing.redirect '/'
          end

          # GET /outline/video_id
          routing.get do
            begin
              video = Youtube::VideoMapper
                .new(App.config.API_KEY).find(video_id)
            rescue StandardError => err
              App.logger.error err.backtrace.join("DB READ PROJ\n")
              flash[:error] = MSG_VID_NOT_FOUND
              response.status = 404
              routing.redirect '/'
            end
            begin
              Repository::For.entity(video).create(video)
            rescue StandardError
              flash[:error] = MSG_VID_EXISTS
              routing.redirect '/'
            end

            # Add new video to watched set in cookies
            session[:watching].insert(0, video.video_id).uniq!
            begin
              video = Repository::For.klass(Entity::Video).find_id(video_id)
            rescue StandardError
              flash[:error] = MSG_VIDINFO_NOT_FOUND
              response.status = 410
              routing.redirect '/'
            end
            view 'outline', locals: { video: video }
          rescue StandardError => err
            puts "Error: #{err.message} at #{err.backtrace.first}" # Output to console
            # view 'error', locals: { error_message: e.message }
            flash[:error] = MSG_SERVER_ERROR
            routing.redirect '/'
          end
        end
      end
      # routing.on 'channel' do
      #   routing.is do
      #     # POST /channel/
      #     routing.post do
      #       yt_url = routing.params['youtube_url']
      #       routing.halt(400, 'YouTube channel URL parameter is required') unless yt_url

      #       routing.halt(400, 'Invalid YouTube URL') unless (yt_url.include? 'googleapis.com') &&
      #                                                       (yt_url.include? '/channels/') &&
      #                                                       (yt_url.split('/').count >= 5)
      #       channel_id = yt_url.split('/').last

      #       channel = Youtube::ChannelMapper
      #         .new(App.config.API_KEY).find(channel_id)
      #       Repository::For.entity(channel).create_or_update(channel)
      #       routing.redirect "channel/#{channel_id}"
      #     end
      #   end

      #   routing.on String do |channel_id|
      #     # GET /channel/channel_id
      #     routing.get do
      #       channel = Repository::For.klass(Entity::Channel).find_channel_id(channel_id)
      #       view 'channel', locals: { channel: channel }
      #     end
      #   end
      # end
    end
  end
end
