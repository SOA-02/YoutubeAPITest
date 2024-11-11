# frozen_string_literal: true

require 'dry-validation'

module Outline
  module Forms
    # Validation for new search form
    class NewSearch < Dry::Validation::Contract
      MSG_NO_EMPTY_VALUE = 'Please do not enter an empty value.'

      params do
        required(:keywords).filled(:string)
      end

      rule(:keywords) do
        key.failure(MSG_NO_EMPTY_VALUE)
      end
    end
  end
end
