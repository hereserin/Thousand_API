class Api::PagesController < ApplicationController
  def index
    @pages = Page.order(page_rank: :desc).limit(10)
    render 'api/pages/index'
  end

end
