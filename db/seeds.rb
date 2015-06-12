require 'open-uri'
require 'nokogiri'

Card.delete_all

url = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words"
document = Nokogiri::HTML(open(url))
index = document.css("tr + tr")

index.take(15).each do |word|
  original_text   = word.at_css("td:nth-child(2)").text
  translated_text = word.at_css("td:nth-child(3)").text
  Card.create(original_text: original_text,
              translated_text: translated_text,
              review_date: Time.now)
end
