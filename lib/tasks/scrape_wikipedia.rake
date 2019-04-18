require 'wikipedia_scraper'

namespace :db do
  namespace :seed do

    desc 'Scrape Wikipedia'
    task :scrape_wikipedia => :environment do
      Page.delete_all
      Paragraph.delete_all
      PagesOutboundLink.delete_all

      File.open("scrape_results.txt", "w+") do |page|
        spider = WikipediaScraper.new
        spider.results.lazy.take(5).each_with_index do |result, i|
          output_string = "%-3s: %s" % [i, result.inspect]
          page.write(output_string)
          puts "===="
        end
      end
      all_pages = Page.includes(:outbound_links).includes(:inbound_links).all
      num_of_pages = all_pages.count
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts " =====>   " + num_of_pages.to_s + " pages have been indexed."
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "Thats all folks!"
    end
  end
end
