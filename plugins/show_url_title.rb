module Cinch::Plugins
  class ShowURLTitle
    include Cinch::Plugin

    set plugin_name: "Show URL Title",
    help: "Scrapes the titles of URLs mentioned and announces them."

    listen_to :channel

    def show_url_title(url)
      doc = Nokogiri::HTML(open(url))
      doc.title == nil ? "No title" : doc.title
    end

    def listen(m)
      urls = URI.extract(m.message, "http")
      unless urls.empty?
        url_titles = urls.map {|url| show_url_title(url) }.compact
        m.reply("#{Format(:yellow, url_titles.join(", "))}", false)
      end
    end
  end
end