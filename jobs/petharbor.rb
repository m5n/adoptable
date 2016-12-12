require 'json'
require 'nokogiri'
require 'open-uri'
require 'time'
require File.expand_path('../../lib/ad', __FILE__)
require File.expand_path('../../lib/job', __FILE__)

name = "PetHarbor"
max_shelters = 140
url_prefix = "http://petharbor.com/"

Adoptable::Job.new(name).run do |target_species, target_breeds, target_exclude_breeds, target_gender, target_age, target_zip, target_distance|
  # PetHarbor does 200 miles max distance, if > 200 is specified, 64 miles is used so be precise
  distance = [200, target_distance].min

  # Gather shelters
  resource = open("http://petharbor.com/pick_shelter.asp?searchtype=ADOPT&stylesheet=include/default.css&frontdoor=1&friends=1&samaritans=1&nosuccess=0&rows=10&imght=120&imgres=thumb&tWidth=200&view=sysadm.v_animal_short&fontface=arial&fontsize=10&zip=#{target_zip}&miles=#{distance}&atype=")
  doc = Nokogiri::HTML(resource)
  shelter_ids = doc.css('.searchResultRow').collect { |elt| elt.css('input').attr('name').value[3..-1] } 
  p "#{name}: Searching #{shelter_ids.length} shelters in #{target_zip}"

  # Avoid rate limiting
  sleep(5)

  ads = []

 target_breeds.each do |breed|
  gender = target_gender.downcase[0, 1]

  # Convert settings to site-specific codes
  age =
    # TODO: add all ages
    case target_age.downcase
    when 'puppy' then 'y'
    else raise "Unknown age: #{target_age}"
    end

  dummy_time = Time.now
  # Search the max #shelters at a time
  while shelter_ids.length > 0
    subset = shelter_ids.slice!(0, max_shelters)
    doc = Nokogiri::HTML(open("http://petharbor.com/results.asp?searchtype=ADOPT&stylesheet=include/default.css&frontdoor=1&grid=1&friends=1&samaritans=1&nosuccess=0&rows=24&imght=120&imgres=thumb&tWidth=200&view=sysadm.v_animal&fontface=arial&fontsize=10&zip=#{target_zip}&miles=#{distance}&shelterlist=#{subset.map { |s| "%27#{s}%27" }.join(",")}&atype=#{target_species.downcase}&ADDR=undefined&nav=1&start=4&nomax=1&page=1&where=type_#{target_species.upcase},gender_#{gender},age_#{age},breed_#{breed.upcase}"))
    doc.css('.gridResult').each do |elt|
      url = "#{url_prefix}#{elt.css('a').attr('href')}"
      id = /ID=(\w+)/.match(url)[1]
      notes = ["Location not available--not specified in results"]
      begin
        time = Time.strptime(elt.css('.gridText')[5].text, "%Y.%m.%d")
      rescue 
        raise "Unexpected date: #{elt.css('.gridText')[5].text}" if elt.css('.gridText')[5].text != "Unknown Date"
        time = dummy_time -= 24 * 60 * 60
        notes.push("Date not accurate--not specified in results")
      end
      photo = "#{url_prefix}#{elt.css('img').attr('src')}"

      # loc != zip of shelter; don't use it
      #loc = /LOCATION=(\w+)/.match(photo)[1]
      city = elt.css('.gridText')[6].text   # Use shelter name in lieu of actual city name

      breed = elt.css('.gridText')[3].text
      next if target_exclude_breeds.any? { |b| !breed.upcase[b.upcase].nil? }

      ads.push(Adoptable::Ad.new(name, id, time, photo, url, city, notes))
    end

    # Avoid rate limiting
    sleep(5)
  end

 end
 ads
end
