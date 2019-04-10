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
