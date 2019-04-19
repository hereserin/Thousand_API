desc 'Nothing much...just playing with rake...'
task :nothing_much => :environment do
    # first_page = Page.first
    # last_page = Page.last
    # debugger
    #
    # number = 4 + 5
    my_url = "http://www.venturerepublic.com/resources/Branding_celebrities_brand_endorsements_brand_leadership.asp"
    paragraph_agent = Mechanize.new
    if my_url.strip[-4..-1] == ".asp"
      p "something"
      debugger
      p "something"
    end

    begin
      page = paragraph_agent.get(my_url)
    rescue Mechanize::ResponseCodeError => e
      p e.class
      p "hit error"
      debugger
      p "line two"
    rescue SocketError => e
      p e.class
      p "hit error"
      debugger
      p "line two"
    rescue Net::OpenTimeout => e
      p e.class
      p "hit error"
      debugger
      p "line two"
    rescue Timeout::Error => e
      p e.class
      p "hit error"
      debugger
      p "line two"
    rescue Exception => e
      p e.class
      p "hit error"
      debugger
      p "line two"
    end

    debugger
    page.search('p').each do |paragraph|
      puts paragraph_agent
    end

end
