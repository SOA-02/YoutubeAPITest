# frozen_string_literal: true

require 'dry-validation'

module Outline
  module Forms
    # Validation for new search form
    class NewSearch < Dry::Validation::Contract
      INPUT_REGEX = /\A(?!.*<script>|.*javascript:)[\p{L}\p{N}\p{P}]*\p{L}[\p{L}\p{N}\p{P}]*\z/
      MSG_INVALID_INPUT = 'Please enter a non-empty value that contains letters or numbers.'

      params do
        required(:keywords).filled(:string)
      end

      rule(:keywords) do
        key.failure(MSG_INVALID_INPUT) unless INPUT_REGEX.match?(value)
      end
    end
  end
end
