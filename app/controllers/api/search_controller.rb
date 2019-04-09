class Api::SearchController < ApplicationController

  def index
    if params[:query].empty?
      @pages = Page.order(page_rank: :desc).limit(10)
    else
      @pages = Page.search_titles(query_to_array(params[:query]))
    end

    render 'api/pages/index'
  end

  private
  def search_params
    params.require(:page).permit(:query)
  end

  def query_to_array(query_str)
    query_str.split("+")
  end

end
