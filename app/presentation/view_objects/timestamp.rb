# frozen_string_literal: true

require_relative 'video'

module Views
  # Parse timestamps from video description
  class Timestamp
    def initialize(description)
      @description = description
    end

    def extract_toc
      timestamps = @description.scan(/(\d{1,2}:\d{2}(?::\d{2})?)\s+(.*)/)
      timestamps.map { |time, title| [time, title] }
    end
  end
end
