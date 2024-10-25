# frozen_string_literal: true

require 'roda'
require 'slim'

module Outline
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        channel = Repository::For.klass(Entity::Channel).all
        view 'home', locals: { channel: }
      end

      routing.on 'channel' do
        routing.is do
          # POST /channel/
          routing.post do
            yt_url = routing.params['youtube_url']
            routing.halt(400, 'youtube_channel_url parameter is required') unless yt_url

            routing.halt(400, 'Invalid YouTube URL') unless (yt_url.include? 'googleapis.com') &&
                                                            (yt_url.include? '/channels/') &&
                                                            (yt_url.split('/').count >= 5)
            channel_id = yt_url.split('/').last

            channel = Youtube::ChannelMapper
              .new(App.config.API_KEY).find(channel_id)
            # Add project to database
            Repository::For.entity(channel).create_or_update(channel)
            # Redirect viewer to project page
            routing.redirect "channel/#{channel_id}"
          end
        end

        routing.on String do |channel_id|
          # GET /channel/channel_id
          routing.get do
            # Get project from database

            channel = Repository::For.klass(Entity::Channel)
              .find_channel_id(channel_id)

            view 'channel', locals: { channel: channel }
          end
        end
      end
    end
  end
end
