class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :runtime, :synopsis, :failure

  def scrape_new_movie(url)
    begin
      doc= Nokogiri::HTML(open(url))
      doc.css('script').remove
      self.title = doc.at("h1[data-type='title']//text()").text
      self.hotness = doc.css('a#tomato_meter_link > span.meter-value').text.to_i
      self.image_url = doc.at_css('#movie-image-section img')['src']
      self.rating = doc.css("ul.content-meta>li:first-child>div.meta-value").text
      self.director = doc.css("ul.content-meta>li:nth-child(3)>div.meta-value").text
      self.genre = doc.css("ul.content-meta>li:nth-child(2)>div.meta-value").text
      self.runtime = doc.css("ul.content-meta>li:nth-child(7)>div.meta-value").text
      s = doc.css('#movieSynopsis').text
      if !s.valid_encoding?
        s= s.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
      end
      self.synopsis = s
      return true
    rescue Exception => e
      self.failure = "Something went wrong with the scrape"
    end
  end
end
