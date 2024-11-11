module Outline
  module Service
    class SearchService
      def call(params)
        form = Forms::SearchKeywordForm.new.call(params)
        return Failure(form.errors.to_h) unless form.success?

        search_key_word = form[:search_key_word]
        Success(search_key_word)
      end
    end
  end
end
