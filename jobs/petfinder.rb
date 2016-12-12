require 'json'
require 'open-uri'
require 'time'
require File.expand_path('../../lib/ad', __FILE__)
require File.expand_path('../../lib/job', __FILE__)

name = "Petfinder"
api_key = "98719f8ded45b41f3153f5736d55d162"
pfjs_photo_host = "drpem3xzef3kf.cloudfront.net"   # Extracted from page source

Adoptable::Job.new(name).run do |target_species, target_breeds, target_exclude_breeds, target_gender, target_age, target_zip, target_distance|
 all_ads = []

 target_breeds.each do |breed|
  # Convert zip to geo coords
  geo = `wget -qO- https://www.petfinder.com/v1/locations/geocoder.json --post-data "q=#{target_zip}&api_key=#{api_key}"`
  geo = JSON.parse(geo).first

  # Avoid rate limiting
  sleep(5)

  # Convert settings to site-specific codes
  age =
    # TODO: add all ages
    case target_age.downcase
    when 'puppy' then 'Baby'
    else raise "Unknown age: #{target_age}"
    end

  data = "{\"age\":[\"#{age}\"],\"animal\":\"#{target_species}\",\"distance\":\"#{target_distance}\",\"gender\":[\"#{target_gender}\"],\"location\":\"#{geo["postal_code"]}\",\"lat\":\"#{geo["latitude"]}\",\"lon\":\"#{geo["longitude"]}\",\"-require\":[{\"primary_breed\":\"#{breed}\"},{\"secondary_breed\":\"#{breed}\"}],\"page_number\":0,\"page_size\":18,\"status\":\"Adoptable\",\"sort\":\"geodist() asc, id desc\",\"partialSearch\":0}"
  ads = `wget -qO- https://www.petfinder.com/v1/pets/search.json --post-data "#{URI::encode("query=#{data}&api_key=#{api_key}")}"`
  ads = JSON.parse(ads)["results"]

  ads.reject! { |ad| ad.include?("primary_breed") ? target_exclude_breeds.any? { |b| !ad["primary_breed"].upcase[b.upcase].nil? } : false }
  ads.reject! { |ad| ad.include?("secondary_breed") ? target_exclude_breeds.any? { |b| !ad["secondary_breed"].upcase[b.upcase].nil? } : false }

  all_ads += ads.map { |ad| Adoptable::Ad.new(name, ad["id"], Time.parse(ad["date_updated"]), "//#{pfjs_photo_host}#{ad.has_key?("pet_photo") ? ad["pet_photo"][0] : nil}", "https://www.petfinder.com/petdetail/#{ad["id"]}", "#{ad["locality"]}, #{ad["region_code"]}") }
 end

 all_ads
end
