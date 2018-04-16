require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_info = doc.css(".card-text-container").text.split("\n").drop(1)
    student_urls = doc.css(".student-card a")
    student_hash_array = []
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
    doc = Nokogiri::HTML(open(profile_url))
    hash = {}
    return hash
  end

end
