require 'spider'

class WikipediaScraper
  attr_reader :root, :handler

  def initialize(root: "https://en.wikipedia.org/wiki/Portal:Current_events", handler: :process_index, **options)
    @root = root
    @handler = handler
    @options = options
  end

  def results(&block)
    spider.results(&block)
  end

  def process_index(page, data = {})

    page.links_with(href: %r{/wiki/\w+$}).each do |link|
      spider.enqueue(link.href, :process_wiki, name: link.text)
    end
  end

  def process_wiki(page, data = {} )
    page_record = Page.find_by(url: page.canonical_uri.to_s )
    if page_record
      puts "Found page: " + page_record.title
      page_record.title = page.title # update page title
    else
      page_record = Page.new(url: page.canonical_uri, title: page.title )
    end

    if page_record.save
      puts "Saved the following page: " + page_record.url + " ... " + page_record.title
    else
      puts "** Did NOT save the following page: " + page_record.url
    end

    paragraphs = page.search("p").each_with_object([]) do |paragraph, arr|
      paragraph_record = Paragraph.new( page_id: page_record.id, content: paragraph )
      if paragraph_record.save
        puts "Saved a paragraph with the following id: " + paragraph_record.id.to_s
      else
        puts "** paragraph did not persist **"
      end
      arr << paragraph.text
    end

    links = page.links.each_with_object({}) do |link, o|
      key = link.text

      begin
        val = link.resolved_uri
      rescue URI::InvalidURIError
        next
      end
      # next if  val.to_s =~ /\A#{URI::regexp(['#'])}\z/

      encoded_val = URI.encode(val.to_s)
      # next unless  encoded_val =~ /\A#{URI::regexp(['http', 'https'])}\z/
      o[key] = val

      link_to_page = Page.find_by(url: URI.parse(encoded_val).to_s )
      if link_to_page
        puts "Found link as page: " + link_to_page.title
        link_to_page.update_title(val)
      else
        link_to_page = Page.new(url: URI.parse(encoded_val).to_s, title: link.text )
      end

      if link_to_page.save
        puts "Saved the following link as page: " + link_to_page.url + " ... " + link_to_page.title
        outbound_link_record = PagesOutboundLink.find_by(page_id: page_record.id, outbound_link_id: link_to_page.id )
        if outbound_link_record
          puts "....Outbound link was found "
        else
          outbound_link_record = PagesOutboundLink.new(page_id: page_record.id, outbound_link_id: link_to_page.id )
        end

        if outbound_link_record.save
          puts "....Outbound link has been saved to page."
        end
      else
        puts "** Did NOT save the following link as page: " + link_to_page.url
      end
    end

    spider.record(data.merge(links).merge(paragraphs: paragraphs))
  end

  private

  def spider
    @spider ||= Spider.new(self, @options)
  end
end
