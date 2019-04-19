class Api::PagesController < ApplicationController
  def index
    @pages = Page.includes(:paragraphs).includes(:outbound_links).includes(:inbound_links).order(page_rank: :desc).limit(50)
    # @pages = Page.includes(:paragraphs).limit(50)

    Page.generate_excerpts_for_group(@pages)

    # @pages = Page.joins(:paragraphs).limit(10)
    # @pages = Page.joins(:pages_outbound_links)

    # @pages = [Page.includes(:paragraphs).order(page_rank: :desc).find(38238)]
    # @pages = Page.includes(:paragraphs).order(page_rank: :desc).where(id: 38238)
    # @pages = Page.includes(:paragraphs).order(page_rank: :desc).where(id: 38241)
    # Page.generate_excerpts_for_group(@pages)

    # @paragraphs = Paragraph.all.limit(10)
    render 'api/pages/index'
  end

end
