class SearchesController < ApplicationController
  def index
    @search = Post.search do
      fulltext params[:search]
    end
    @search_result = @search.results
  end
end
