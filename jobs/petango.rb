require 'json'
require 'open-uri'
require 'time'
require File.expand_path('../../lib/ad', __FILE__)
require File.expand_path('../../lib/job', __FILE__)

name = "Petango"
cookieFile = "PetangoCookies.txt"

Adoptable::Job.new(name).run do |target_species, target_breeds, target_exclude_breeds, target_gender, target_age, target_zip, target_distance|
 all_ads = []

 target_breeds.each do |breed|
  # Convert settings to site-specific codes
  species_id =
    # TODO: add all species
    case target_species.downcase
    when 'dog' then 1
    else raise "Unknown species: #{target_species}"
    end

  breed_id = 
    # TODO: add all breeds
    case breed.downcase
    when 'havanese' then 787
    when 'maltese' then 705
    when 'yorkie' then 715
    when 'yorkshire' then 715
    else raise "Unknown breed: #{breed}"
    end

  age =
    # TODO: add all ages
    case target_age.downcase
    when 'puppy' then 'Baby'
    else raise "Unknown age: #{target_age}"
    end

  gender = target_gender.upcase[0, 1]

  token = nil
  `wget -qO- http://www.petango.com/advancedSearch --save-cookies #{cookieFile} --keep-session-cookies --delete-after`
  File.foreach(cookieFile) do |l|
    matches = /RequestVerificationToken\t(.*)/.match(l.chomp)
    if !matches.nil?
      token = matches[1]
      break;
    end
  end
  File.delete(cookieFile)

  # Avoid rate limiting
  sleep(5)

  data = "{\"location\":\"#{target_zip}\",\"distance\":\"#{target_distance}\",\"speciesId\":\"#{species_id}\",\"breedId\":\"#{breed_id}\",\"gender\":\"#{gender}\",\"size\":\"\",\"age\":\"#{age}\",\"color\":\"\",\"goodWithDogs\":false,\"goodWithCats\":false,\"goodWithChildren\":false,\"mustHavePhoto\":false,\"mustHaveVideo\":false,\"declawed\":\"\",\"happyTails\":false,\"lostAnimals\":false,\"moduleId\":843,\"recordOffset\":0,\"recordAmount\":26}"
  ads = `wget -qO- --load-cookies #{cookieFile} http://www.petango.com/DesktopModules/Pethealth.Petango/Pethealth.Petango.DnnModules.AnimalSearchResult/API/Main/Search --post-data '#{data}' --header 'RequestVerificationToken: #{token}' --header 'TabId: 260' --header 'ModuleId: 843' --header "Content-Type: application/json; charset=UTF-8"`
  ads = JSON.parse(ads)["items"]
  # TODO: fix time param; there is no date in the ad record?!
  time = Time.now
  notes = ["Location not available--only distance in miles available"]

  ads.reject! { |ad| target_exclude_breeds.any? { |b| !ad["breed"].upcase[b.upcase].nil? } }

  all_ads += ads.map { |ad| Adoptable::Ad.new(name, ad["id"], time -= 24 * 60 * 60, ad["photo"], ad["url"], "#{ad["distance"]} mi", notes) }
 end

 all_ads
end
