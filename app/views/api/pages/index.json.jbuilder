json.pages do
  @pages.each do |page|
    json.set! page.id do
      json.extract! page, :title, :url, :page_rank
    end
  end
end
