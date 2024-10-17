# frozen_string_literal: true

#require_relative 'channel'
#require_relative 'playlist'

require 'dry-struct'
require 'dry-types'
require 'yaml'
require_relative '../../../app/models/gateways/video_api'

config = YAML.load_file(File.expand_path('../../../config/secrets.yml', __dir__))

# Define the Types module for Dry Types
module Types
  include Dry.Types()
end

# Video entity
module Outline
  module Entity
    # Video entity
    class Video < Dry::Struct
      include Dry.Types
  
      attribute :id, Types::Strict::String
      attribute :title, Types::Strict::String
      attribute :description, Types::Strict::String
      attribute :published_at, Types::Strict::Time
      attribute :thumbnail_url, Types::Strict::String
    end
  end
end

# Example Usage
example_response = Outline::Entity::Video.new(
  id: '1234567890',
  title: 'Sample Video Title',
  description: 'This is a sample video description.',
  published_at: Time.now,
  thumbnail_url: 'https://example.com/thumbnail.jpg'
)

example_video = Outline::Entity::Video.new(example_response.to_h)
puts example_video.id

# Actual Usage
api_key = config['API_KEY']
video_id = 'jeqH4eMGjhY'

api_response = Outline::YoutubeApi.new(api_key)
video = Outline::Entity::Video.new(api_response.to_h)
puts video.id
