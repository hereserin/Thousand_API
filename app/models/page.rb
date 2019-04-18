class Page < ApplicationRecord
  has_many :paragraphs

  has_many :pages_inbound_links,
    class_name: 'PagesOutboundLink',
    foreign_key: :outbound_link_id,
    primary_key: :id

  has_many :inbound_links,
    through: :pages_inbound_links,
    source: :outbound_link


  has_many :pages_outbound_links,
    class_name: 'PagesOutboundLink',
    foreign_key: :page_id,
    primary_key: :id

  has_many :outbound_links,
    through: :pages_outbound_links,
    source: :page

  def total_outbound_links
    @total_outbound_links ||= self.outbound_links.count
    @total_outbound_links
  end

  def create_own_row(all_pages, lookup_hsh)
    all_pages_count = all_pages.count
    adj_mtx_row = Array.new(all_pages_count, 0)

    self.outbound_links.each do |link|
      links_to_that_page = self.outbound_links.select {|same_page| link.id == same_page.id }
      adj_func = links_to_that_page.count / all_pages_count.to_f

      adj_mtx_row[lookup_hsh[link.id]] = adj_func
    end

    return adj_mtx_row
  end

  def update_title(new_title)
    self.title = new_title
    if self.save
      puts "Title updated, file saved. "
    end

  end

  def self.search_titles(query_array)
    if query_array.length == 1
      return Page
        .includes(:paragraphs)
        .where("lower(title) LIKE ?",
        "%#{query_array[0].downcase}%")
    end

    Page
    .includes(:paragraphs)
    .where("lower(title) LIKE ?",
    "%#{query_array[-1].downcase}%")
      .or(Page.search_titles(query_array[0..-2]))
  end

  def assign_display_excerpt(str)
    @display_excerpt = str
  end

  def display_excerpt
    @display_excerpt ||= "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    @display_excerpt
  end

  def get_contents
    contents = self.paragraphs
    return contents if contents.length > 0
    action = :pending
    action = self.record_paragraphs
    until action == :complete
      sleep 0.01
    end
    self.paragraphs
  end

  def record_paragraphs
    paragraph_agent = Mechanize.new
    paragraph_count = 0
    begin
      page = paragraph_agent.get(self.url)
      page.search('p').each do |paragraph|
        break if paragraph_count > 20
        next if paragraph.content.strip.length < 15
        paragraph_record = Paragraph.new( page_id: self.id, content: paragraph.content.strip )

        if paragraph_record.save
          puts "Saved a paragraph with the following id: " + paragraph_record.id.to_s
        else
          puts "** paragraph did not persist **"
          debugger
        end
        paragraph_count += 1
      end
    rescue Mechanize::ResponseCodeError => e
      p e.class
    rescue SocketError => e
      p e.class
    end
    return :complete
  end

  def self.generate_excerpts_for_group(pages_arr)
    pages_arr.each do |page|
      excerpt = ""
      contents = page.get_contents
      contents.each do |paragraph|
        break if excerpt.length > 200
        excerpt += paragraph.content
        excerpt += " "
      end
      page.assign_display_excerpt(excerpt)
    end
  end

end


  # ** old version **
  #
  # def create_own_row(all_pages)
  #   adj_mtx_row = []
  #   all_pages_count = all_pages.count
  #
  #   all_pages.each do |page|
  #     adj_func = 0
  #
  #     links_to_that_page = self.outbound_links.select {|link| link.id == page.id }
  #     if links_to_that_page.count > 0
  #       adj_func = links_to_that_page.count / all_pages_count
  #     end
  #     puts "  pushing ratio: " + adj_func.to_s
  #     adj_mtx_row << adj_func
  #   end
  #
  #   return adj_mtx_row
  # end
