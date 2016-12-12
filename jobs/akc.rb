require 'json'
require 'nokogiri'
require 'open-uri'
require 'time'
require File.expand_path('../../lib/ad', __FILE__)
require File.expand_path('../../lib/job', __FILE__)

name = "AKC"

Adoptable::Job.new(name).run do |target_species, target_breeds, target_exclude_breeds, target_gender, target_age, target_zip, target_distance|
 return [] if target_species.upcase != "DOG"

 ads = []

 target_breeds.each do |breed|
  # Convert settings to site-specific codes
  # TODO: do this rather than capitalize

  breed_id = 
    # TODO: add all breeds
    case breed.downcase
    when 'havanese' then 132
    when 'maltese' then 160
    when 'yorkie' then 260
    when 'yorkshire' then 260
    else raise "Unknown breed: #{breed}"
    end

  notes = ["Date shown is date of birth"]

  doc = Nokogiri::HTML(open("http://marketplace.akc.org/search?breed=#{breed_id}&gender=has-#{target_gender.downcase}&location=#{target_zip}&radius=#{target_distance}"))

  doc.css('.search-results__item a').each do |elt|
    # Avoid rate limiting
    # Also do first time because we just got the shelters
    sleep(5)

    href = elt.attr('href')
    doc = Nokogiri::HTML(open("http://marketplace.akc.org#{href}"))

    # Avoid "no _dump_data is defined for class Nokogiri::XML::Attr" error by converting attr() to string in various places
    default_photo = doc.css('.storefront-cover img')[0].attr('src').to_s
    breeder = doc.css('.storefront-cover h1')[0].text
    distinction = doc.css('.storefront-cover h2')[0].text if doc.css('.storefront-cover h2').length > 0
    city = doc.css('.storefront__information--contact p')[0].text.gsub(/\d+$/, '')
    doc.css('.container-listings__item').each do |elt|
      id = elt.css('a').attr('data-tile-listing-id').to_s
      url = elt.css('a').attr('href').to_s
      photo = elt.css('img')[0].attr('src').to_s
      photo = default_photo if photo["storefront-default"]
      ad_breed = elt.css('.horizontal-media-box__item-breeds')[0].text
      dob = elt.css('p')[1].text[5..-1]
      time = Time.strptime(dob, "%m/%d/%Y")

      # Puppies of all breeds this breeders breeds are listed
      if !ad_breed.downcase[breed.downcase].nil? then
        ads.push(Adoptable::Ad.new("#{name} - #{breeder}", id, time, photo, url, city, notes))
      end
    end
  end
 end

 ads
end
