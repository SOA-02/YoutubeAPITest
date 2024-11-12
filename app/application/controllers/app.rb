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
      'style.css',
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
                    css: css_files,
                    js: js_files
    plugin :common_logger, $stderr

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    MSG_GET_STARTED = 'Please enter the keywords you are interested in to get started.'
    MSG_SERVER_ERROR = 'Internal Server Error'

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # Load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        # Get cookie viewer's previously seen videos
        session[:watching] ||= []
        result = Service::FetchViewedVideos.new.call(session[:watching])
        if result.failure?
          flash[:error] = result.failure
          viewable_videos = []
        else
          videos = result.value!
          flash.now[:notice] = MSG_GET_STARTED if videos.none?
          session[:watching] = videos.map(&:video_id)
          viewable_videos = Views::VideosList.new(videos)
        end
        view 'home', locals: { videos: viewable_videos }
      end
      routing.on 'search' do
        routing.is do
          # POST /search/
          routing.post do
            key_word_request = Forms::NewSearch.new.call(routing.params)
            if key_word_request.errors.empty?
              key_word = key_word_request[:search_key_word]
              routing.redirect "search/#{key_word}"
            else
              flash[:error] = key_word_request.errors[:search_key_word].first
              routing.redirect '/'
            end
          end
        end

        routing.on String do |key_word|
          # GET /search/key_word
          routing.get do
            results = Service::SearchService.new.video_from_youtube(key_word)
            if results.failure?
              flash[:error] = results.failure
              routing.redirect '/'
            else
              @search_results = results.value!
              view 'search', locals: { search_results: @search_results }
            end
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
          session[:watching].insert(0, video_id).uniq!
          # DELETE /outline/{video_id}
          routing.delete do
            session[:watching].delete(video_id)
            routing.redirect '/'
          end

          # GET /outline/video_id
          routing.get do
            video_made = Service::AddVideo.new.call(video_id)
            if video_made.failure?
              flash[:error] = video_made.failure
              routing.redirect '/'
            else
              # Extract timestamps from description data
              @video = video_made.value![:local_video]
              binding.irb
              timestamp_parser = Views::Timestamp.new(@video.video_description)
              toc = timestamp_parser.extract_toc
              view 'outline', locals: { video: @video, toc: toc }

            end
          end
        end
      end
    end
  end
end
