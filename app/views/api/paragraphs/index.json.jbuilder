json.paragraphs do
  @paragraphs.each do |para|
    json.set! para.id do
      json.extract! para, :page_id, :content
    end
  end
end
