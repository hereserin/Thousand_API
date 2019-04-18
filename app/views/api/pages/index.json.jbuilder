json.pages do
  @pages.each do |page|
    json.set! page.id do
      json.extract! page, :title, :url, :page_rank
      # json.paragraphs page.paragraphs.pluck(:id)
      # json.outbound_links page.outbound_links.pluck(:id)
      json.excerpt page.display_excerpt
    end
  end
end

# json.paragraphs do
#   @paragraphs.each do |para|
#     json.set! para.id do
#       json.extract! para, :page_id, :content
#     end
#   end
# end
