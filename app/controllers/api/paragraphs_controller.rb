class Api::ParagraphsController < ApplicationController
  def index
    # @pages = Page.includes(:paragraphs).order(page_rank: :desc)
    @paragraphs = Paragraph.limit(100)

    render 'api/paragraphs/index'
  end

end
