require 'json'
require 'nokogiri'
require 'open-uri'
require 'time'
require File.expand_path('../../lib/ad', __FILE__)
require File.expand_path('../../lib/job', __FILE__)

name = "Overstock"

Adoptable::Job.new(name).run do |target_species, target_breeds, target_exclude_breeds, target_gender, target_age, target_zip, target_distance|
 ads = []

 target_breeds.each do |breed|
  # Convert settings to site-specific codes
  # TODO: do this rather than capitalize
  breed_id = 
    # TODO: add all breeds
    case breed.downcase
    when 'bolognese' then 'Bichon-Frise'
    when 'cavalier king charles spaniel' then 'Cavalier-King-Charles-Spaniel'
    when 'coton de tulear' then 'Coton-De-Tulear'
    when 'english toy spaniel' then 'Cavalier-King-Charles-Spaniel'
    when 'cocker spaniel' then 'Cocker-Spaniel'
    when 'english cocker spaniel' then 'English-Cocker-Spaniel'
    when 'havanese' then 'Havanese'
    when 'italian greyhound' then 'Italian-Greyhound'
    when 'maltese' then 'Maltese'
    when 'miniature poodle' then 'Poodle-Miniature'
    when 'pomeranian' then 'Pomeranian'
    when 'papillon' then 'Papillon'
    when 'toy poodle' then 'Poodle-Toy'
    when 'portuguese podengo' then 'Podengo-Portugueso'
    when 'portuguese podengo pequeno' then 'Podengo-Portugueso'
    when 'yorkie' then 'Yorkshire-Terrier-Yorkie'
    when 'yorkshire terrier' then 'Yorkshire-Terrier-Yorkie'
    else raise "Unknown breed: #{breed}"
    end

  age =
    # TODO: add all ages
    case target_age.downcase
    when 'puppy' then 'Baby'
    else raise "Unknown age: #{target_age}"
    end

  doc = Nokogiri::HTML(open("https://pets.overstock.com/pets/#{target_species.capitalize},#{breed_id},#{age},#{target_gender.capitalize}/species,breed,age,sex,/#{target_zip}?distance=#{target_distance}"))

  time = Time.now
  doc.css('.pet-tile').each do |elt|
    url = "https://pets.overstock.com" + elt.css('.image-link')[0].attr('href')
    id = /\/pets\/(\d+)/.match(url)[1]
    breed = elt.css('.pet-type')[0].text
    city = elt.css('.pet-loc')[0].text
    img_src = elt.css('.pet-image')[0]
    photo = img_src.attr('src') if !img_src.nil?

    # TODO: fix time param; there is no date in the ad record?!
    notes = ["Date not accurate--not specified in results"]

    next if target_exclude_breeds.any? { |b| !breed.upcase[b.upcase].nil? }

    ads.push(Adoptable::Ad.new(name, id, time -= 24 * 60 * 60, breed, photo, url, city, notes))
  end
 end

 ads
end
