require 'open-uri'
require 'nokogiri'

Card.delete_all

url = "http://www.languagehelpers.com/words/german/basic.html"
document = Nokogiri::HTML(open(url))
index = document.css("tr + tr")

index.take(15).each do |word|
  original_text   = word.at_css("td:nth-child(1)").text
  translated_text = word.at_css("td:nth-child(2)").text
  Card.create(original_text: original_text,
              translated_text: translated_text,
              user_id: 9001,
              review_date: Date.today)
end
