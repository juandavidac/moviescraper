class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :runtime, :synopsis, :failure

  def scrape_new_movie
    begin
      doc= Nokogiri::HTML(open("https://www.rottentomatoes.com/m/your_name_2017#contentReviews"))
      doc.css('script').remove
      self.title = doc.at("h1[data-type='title']//text()").text
      self.hotness = doc.css('a#tomato_meter_link > span.meter-value').text.to_i
      self.image_url = doc.at_css('#movie-image-section img')['src']
      self.rating = doc.css("ul.content-meta>li:first-child>div.meta-value").text
      self.director = doc.css("ul.content-meta>li:nth-child(3)>div.meta-value").text
      self.genre = doc.css("ul.content-meta>li:nth-child(2)>div.meta-value").text
      self.runtime = doc.css("ul.content-meta>li:nth-child(7)>div.meta-value").text
      self.synopsis = doc.css('#movieSynopsis').text
      return true
    rescue Exception => e
      self.failure = "Something went wrong with the scrape"
    end
  end

  def save_movie
    movie= Movie.new(
      title: self.title,
      hotness: self.hotness,
      image_url: self.image_url,
      synopsis: self.synopsis,
      rating: self.rating,
      genre: self.genre,
      director: self.director,
      runtime: self.runtime, 
      user_id: 1
    )
    movie.save
  end
end
