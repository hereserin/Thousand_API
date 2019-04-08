class Api::SearchController < ApplicationController

  def index
    if params[:query].empty?
      @page = Page.includes(:paragraphs).all
    else

      @page = Page.search_titles(query_to_array(params[:query]))
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
