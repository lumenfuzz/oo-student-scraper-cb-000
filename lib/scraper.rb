require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_hash_array = []
    doc = Nokogiri::HTML(open(index_url))
    student_info = doc.css(".card-text-container").text.split("\n").drop(1)
    student_urls = doc.css(".student-card a")
    i = 0
    student_urls.each do |student_url|
      student_hash_array << {
        :name => student_info[i*3].strip,
        :location => student_info[i*3+1].strip,
        :profile_url => student_url["href"]
      }
      i += 1
    end
    return student_hash_array
  end

  def self.scrape_profile_page(profile_url)
    hash = {}
    doc = Nokogiri::HTML(open(profile_url))
    social_media = doc.css(".social-icon-container a")
    social_media.each do |media_html|
      media_url = media_html["href"]
      if media_url.start_with? "https://twitter.com"
        hash[:twitter] = media_url
      elsif media_url.start_with? "https://www.linkedin.com"
        hash[:linkedin] = media_url
      elsif media_url.start_with? "https://github.com"
        hash[:github] = media_url
      else
        hash[:blog] = media_url
      end
    end
    hash[:profile_quote] = doc.css(".vitals-text-container .profile-quote")
    hash[:bio] = doc.css(".bio-block .description-holder")
    return hash
  end

end
