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
  p "#{name}: Searching #{shelter_ids.length} shelters near #{target_zip}"

  ads = []

 target_breeds.each do |breed|
  gender = target_gender.downcase[0, 1]

  # Convert settings to site-specific codes
  # document.querySelectorAll('[name=cmbBreedList] option').forEach(function (o) { if (o.getAttribute('value') !== 'No Preference') { console.log('    when \'' + o.innerText.toLowerCase() + '\' then \'' + o.getAttribute('value').split('^')[1].replace(' ', '%20') + '\''); }})
  breed_id = 
    case breed.downcase
    when 'affenpinscher' then 'AFFENPINSCHER'
    when 'afghan hound' then 'AFGHAN%20HOUND'
    when 'airedale terrier' then 'AIREDALE%20TERR'
    when 'akbash' then 'AKBASH'
    when 'akita' then 'AKITA'
    when 'alaskan husky' then 'ALASKAN%20HUSKY'
    when 'alaskan klee kai' then 'ALASK%20KLEE KAI'
    when 'alaskan malamute' then 'ALASK%20MALAMUTE'
    when 'american bulldog' then 'AMER%20BULLDOG'
    when 'american eskimo' then 'AMER%20ESKIMO'
    when 'american foxhound' then 'AMER%20FOXHOUND'
    when 'american pit bull terrier' then 'AM%20PIT BULL TER'
    when 'american staffordshire terrier' then 'AMERICAN%20STAFF'
    when 'american water spaniel' then 'AMER%20WATER SPAN'
    when 'anatolian shepherd' then 'ANATOL%20SHEPHERD'
    when 'australian cattle dog' then 'AUST%20CATTLE DOG'
    when 'australian kelpie' then 'AUST%20KELPIE'
    when 'australian shepherd' then 'AUST%20SHEPHERD'
    when 'australian terrier' then 'AUST%20TERRIER'
    when 'basenji' then 'BASENJI'
    when 'basset hound' then 'BASSET%20HOUND'
    when 'beagle' then 'BEAGLE'
    when 'bearded collie' then 'BEARDED%20COLLIE'
    when 'beauceron' then 'BEAUCERON'
    when 'bedlington terrier' then 'BEDLINGTON%20TERR'
    when 'belgian laekenois' then 'BELG%20LAEKENOIS'
    when 'belgian malinois' then 'BELG%20MALINOIS'
    when 'belgian sheepdog' then 'BELG%20SHEEPDOG'
    when 'belgian tervuren' then 'BELG%20TERVUREN'
    when 'bernese hound' then 'BERNESE%20HOUND'
    when 'bernese mountain dog' then 'BERNESE%20MTN DOG'
    when 'bichon frise' then 'BICHON%20FRISE'
    when 'black and tan coonhound' then 'BLACK/TAN%20HOUND'
    when 'black mouth cur' then 'BLACK%20MOUTH CUR'
    when 'bloodhound' then 'BLOODHOUND'
    when 'blue lacy' then 'BLUE%20LACY'
    when 'bluetick coonhound' then 'BLUETICK%20HOUND'
    when 'boerboel' then 'BOERBOEL'
    when 'bolognese' then 'BICHON%20FRISE'
    when 'border collie' then 'BORDER%20COLLIE'
    when 'border terrier' then 'BORDER%20TERRIER'
    when 'borzoi' then 'BORZOI'
    when 'boston terrier' then 'BOSTON%20TERRIER'
    when 'bouvier des flandres' then 'BOUV%20FLANDRES'
    when 'boxer' then 'BOXER'
    when 'boykin spaniel' then 'BOYKIN%20SPAN'
    when 'briard' then 'BRIARD'
    when 'brittany' then 'BRITTANY'
    when 'brussels griffon' then 'BRUSS%20GRIFFON'
    when 'bull terrier' then 'BULL%20TERRIER'
    when 'bull terrier - miniature' then 'BULL%20TERR MIN'
    when 'bulldog' then 'BULLDOG'
    when 'bullmastiff' then 'BULLMASTIFF'
    when 'cairn terrier' then 'CAIRN%20TERRIER'
    when 'canaan dog' then 'CANAAN%20DOG'
    when 'cane corso' then 'CANE%20CORSO'
    when 'carolina dog' then 'CAROLINA%20DOG'
    when 'catahoula leopard hound' then 'CATAHOULA'
    when 'cavalier king charles spaniel' then 'CAVALIER%20SPAN'
    when 'chesapeake bay retriever' then 'CHESA%20BAY RETR'
    when 'chihuahua - long haired' then 'CHIHUAHUA%20LH'
    when 'chihuahua - smooth coated' then 'CHIHUAHUA%20SH'
    when 'chinese crested dog' then 'CHINESE%20CRESTED'
    when 'chinese sharpei' then 'CHINESE%20SHARPEI'
    when 'chow chow' then 'CHOW%20CHOW'
    when 'cirneco dell etna' then 'CIRNECO'
    when 'clumber spaniel' then 'CLUMBER%20SPAN'
    when 'cocker spaniel' then 'COCKER%20SPAN'
    when 'collie - rough' then 'COLLIE%20ROUGH'
    when 'collie - smooth' then 'COLLIE%20SMOOTH'
    when 'coton de tulear' then 'COTON%20DE TULEAR'
    when 'curly-coated retriever' then 'CURLYCOAT%20RETR'
    when 'dachshund' then 'DACHSHUND'
    when 'dachshund - longhaired' then 'DACHSHUND%20LH'
    when 'dachshund - wirehaired' then 'DACHSHUND%20WH'
    when 'dalmatian' then 'DALMATIAN'
    when 'dandie dinmont terrier' then 'DANDIE%20DINMONT'
    when 'doberman pinscher' then 'DOBERMAN%20PINSCH'
    when 'dogo argentino' then 'DOGO%20ARGENTINO'
    when 'dogue de bordeaux' then 'DOGUE%20DE BORDX'
    when 'dutch sheepdog' then 'DUTCH%20SHEEPDOG'
    when 'dutch shepherd' then 'DUTCH%20SHEPHERD'
    when 'english bulldog' then 'ENG%20BULLDOG'
    when 'english cocker spaniel' then 'ENG%20COCKER SPAN'
    when 'english coonhound (redtick coonhound)' then 'ENG%20COONHOUND'
    when 'english foxhound' then 'ENG%20FOXHOUND'
    when 'english pointer' then 'ENG%20POINTER'
    when 'english setter' then 'ENG%20SETTER'
    when 'english shepherd' then 'ENG%20SHEPHERD'
    when 'english springer spaniel' then 'ENG%20SPRNGR SPAN'
    when 'english toy spaniel' then 'ENG%20TOY SPANIEL'
    when 'entlebucher mountain dog' then 'ENTLEBUCHER'
    when 'eurasier' then 'EURASIER'
    when 'feist' then 'FEIST'
    when 'field spaniel' then 'FIELD%20SPANIEL'
    when 'fila brasileiro' then 'FILA'
    when 'finnish spitz' then 'FINNISH%20SPITZ'
    when 'flat-coated retriever' then 'FLAT%20COAT RETR'
    when 'fox terrier - smooth' then 'FOX%20TERR SMOOTH'
    when 'fox terrier - wirehaired' then 'FOX%20TERR WIRE'
    when 'french bulldog' then 'FRENCH%20BULLDOG'
    when 'german pinscher' then 'GERMAN%20PINSCHER'
    when 'german shepherd dog' then 'GERM%20SHEPHERD'
    when 'german shorthaired pointer' then 'GERM%20SH POINT'
    when 'german wirehaired pointer' then 'GERM%20WH POINT'
    when 'glen of imaal terrier' then 'GLEN%20OF IMAAL'
    when 'golden retriever' then 'GOLDEN%20RETR'
    when 'gordon setter' then 'GORDON%20SETTER'
    when 'grand basset griffon vendeen' then 'GBGV'
    when 'great dane' then 'GREAT%20DANE'
    when 'great pyrenees' then 'GREAT%20PYRENEES'
    when 'greater swiss mountain dog' then 'GR%20SWISS MTN'
    when 'greyhound' then 'GREYHOUND'
    when 'harrier' then 'HARRIER'
    when 'havanese' then 'HAVANESE'
    when 'hovawart' then 'HOVAWART'
    when 'ibizan hound' then 'IBIZAN%20HOUND'
    when 'irish setter' then 'IRISH%20SETTER'
    when 'irish terrier' then 'IRISH%20TERRIER'
    when 'irish water spaniel' then 'IRISH%20WATR SPAN'
    when 'irish wolfhound' then 'IRISH%20WOLFHOUND'
    when 'italian greyhound' then 'ITAL%20GREYHOUND'
    when 'jack (parson) russell terrier' then 'JACK%20RUSS TERR'
    when 'japanese chin' then 'JAPANESE%20CHIN'
    when 'kangal' then 'KANGAL'
    when 'karelian bear dog' then 'KARELIAN%20BEAR'
    when 'keeshond' then 'KEESHOND'
    when 'kerry blue terrier' then 'KERRY%20BLUE TERR'
    when 'komondor' then 'KOMONDOR'
    when 'korean jindo' then 'JINDO'
    when 'kuvasz' then 'KUVASZ'
    when 'labrador retriever' then 'LABRADOR%20RETR'
    when 'lakeland terrier' then 'LAKELAND%20TERR'
    when 'landseer' then 'LANDSEER'
    when 'leonberger' then 'LEONBERGER'
    when 'lhasa apso' then 'LHASA%20APSO'
    when 'lowchen' then 'LOWCHEN'
    when 'maltese' then 'MALTESE'
    when 'manchester terrier' then 'MANCHESTER%20TERR'
    when 'maremma sheepdog' then 'MAREMMA%20SHEEPDG'
    when 'mastiff' then 'MASTIFF'
    when 'mexican hairless' then 'MEX%20HAIRLESS'
    when 'miniature pinscher' then 'MIN%20PINSCHER'
    when 'munsterlander' then 'MUNSTERLANDER'
    when 'neapolitan mastiff' then 'NEAPOLITAN%20MAST'
    when 'newfoundland' then 'NEWFOUNDLAND'
    when 'norfolk terrier' then 'NORFOLK%20TERRIER'
    when 'norwegian buhund' then 'NORW%20BUHUND'
    when 'norwegian elkhound' then 'NORW%20ELKHOUND'
    when 'norwich terrier' then 'NORWICH%20TERRIER'
    when 'nova scotia duck-tolling retriever' then 'NS%20DUCK TOLLING'
    when 'old english bulldog' then 'OLD%20ENG BULLDOG'
    when 'old english sheepdog' then 'OLDENG%20SHEEPDOG'
    when 'otterhound' then 'OTTERHOUND'
    when 'papillon' then 'PAPILLON'
    when 'parson (jack) russell terrier' then 'PARSON%20RUSS TER'
    when 'patterdale terrier' then 'PATTERDALE%20TERR'
    when 'pekingese' then 'PEKINGESE'
    when 'petit basset griffon vendeen' then 'PBGV'
    when 'pharaoh hound' then 'PHARAOH%20HOUND'
    when 'picardy sheepdog' then 'PICARDY%20SHEEPDG'
    when 'pit bull terrier' then 'PIT%20BULL'
    when 'plott hound' then 'PLOTT%20HOUND'
    when 'podengo portugueso pequeno' then 'PODENGO%20PEQUENO'
    when 'portuguese podengo' then 'PODENGO%20PEQUENO'
    when 'portuguese podengo pequeno' then 'PODENGO%20PEQUENO'
    when 'pointer' then 'POINTER'
    when 'polish lowland sheepdog' then 'POLISH%20LOWLAND'
    when 'pomeranian' then 'POMERANIAN'
    when 'poodle - miniature' then 'POODLE%20MIN'
    when 'miniature poodle' then 'POODLE%20MIN'
    when 'poodle - standard' then 'POODLE%20STND'
    when 'poodle - toy' then 'POODLE%20TOY'
    when 'toy poodle' then 'POODLE%20TOY'
    when 'portuguese water dog' then 'PORT%20WATER DOG'
    when 'presa canario' then 'PRESA%20CANARIO'
    when 'pug' then 'PUG'
    when 'puli' then 'PULI'
    when 'pumi' then 'PUMI'
    when 'queensland heeler' then 'QUEENSLAND%20HEEL'
    when 'rat terrier' then 'RAT%20TERRIER'
    when 'redbone coonhound' then 'REDBONE%20HOUND'
    when 'rhodesian ridgeback' then 'RHOD%20RIDGEBACK'
    when 'rottweiler' then 'ROTTWEILER'
    when 'saluki' then 'SALUKI'
    when 'samoyed' then 'SAMOYED'
    when 'schipperke' then 'SCHIPPERKE'
    when 'schnauzer - giant' then 'SCHNAUZER%20GIANT'
    when 'schnauzer - miniature' then 'SCHNAUZER%20MIN'
    when 'schnauzer - standard' then 'SCHNAUZER%20STAND'
    when 'scottish deerhound' then 'SCOT%20DEERHOUND'
    when 'scottish terrier' then 'SCOT%20TERRIER'
    when 'sealyham terrier' then 'SEALYHAM%20TERR'
    when 'shetland sheepdog' then 'SHETLD%20SHEEPDOG'
    when 'shiba inu' then 'SHIBA%20INU'
    when 'shih tzu' then 'SHIH%20TZU'
    when 'siberian husky' then 'SIBERIAN%20HUSKY'
    when 'silky terrier' then 'SILKY%20TERRIER'
    when 'skye terrier' then 'SKYE%20TERRIER'
    when 'soft-coated wheaten terrier' then 'SC%20WHEAT TERR'
    when 'spanish mastiff' then 'SPANISH%20MASTIFF'
    when 'spanish water dog' then 'SPAN%20WATER DOG'
    when 'spinone italiano' then 'SPINONE%20ITAL'
    when 'st bernard - rough coated' then 'ST%20BERNARD RGH'
    when 'st bernard - smooth coated' then 'ST%20BERNARD SMTH'
    when 'staffordshire bull terrier' then 'STAFFORDSHIRE'
    when 'sussex spaniel' then 'SUSSEX%20SPAN'
    when 'swedish vallhund' then 'SWED%20VALLHUND'
    when 'swiss hound' then 'SWISS%20HOUND'
    when 'tennessee treeing brindle hound' then 'TENN%20TR BRINDLE'
    when 'tibetan mastiff' then 'TIBETAN%20MASTIFF'
    when 'tibetan spaniel' then 'TIBETAN%20SPAN'
    when 'tibetan terrier' then 'TIBETAN%20TERR'
    when 'tosa' then 'TOSA'
    when 'toy fox terrier' then 'TOY%20FOX TERRIER'
    when 'treeing cur' then 'TREEING%20CUR'
    when 'treeing walker coonhound' then 'TR%20WALKER HOUND'
    when 'vizsla' then 'VIZSLA'
    when 'vizsla - wirehaired' then 'VIZSLA%20WH'
    when 'weimaraner' then 'WEIMARANER'
    when 'welsh corgi - cardigan' then 'WELSH%20CORGI CAR'
    when 'welsh corgi - pembroke' then 'WELSH%20CORGI PEM'
    when 'welsh springer spaniel' then 'WELSH%20SPR SPAN'
    when 'welsh terrier' then 'WELSH%20TERRIER'
    when 'west highland white terrier' then 'WEST%20HIGHLAND'
    when 'whippet' then 'WHIPPET'
    when 'wire-haired pointing griffon' then 'WH%20PT GRIFFON'
    when 'yorkshire terrier' then 'YORKSHIRE%20TERR'
    when 'yorkie' then 'YORKSHIRE%20TERR'
    else raise "Unknown breed: #{breed}"
    end

  age =
    # TODO: add all ages
    case target_age.downcase
    when 'puppy' then 'y'
    else raise "Unknown age: #{target_age}"
    end

  dummy_time = Time.now
  # Search the max #shelters at a time
  while shelter_ids.length > 0
    # Avoid rate limiting
    # Also do first time because we just got the shelters
    sleep(5)

    subset = shelter_ids.slice!(0, max_shelters)
    doc = Nokogiri::HTML(open("http://petharbor.com/results.asp?searchtype=ADOPT&stylesheet=include/default.css&frontdoor=1&grid=1&friends=1&samaritans=1&nosuccess=0&rows=24&imght=120&imgres=thumb&tWidth=200&view=sysadm.v_animal&fontface=arial&fontsize=10&zip=#{target_zip}&miles=#{distance}&shelterlist=#{subset.map { |s| "%27#{s}%27" }.join(",")}&atype=#{target_species.downcase}&ADDR=undefined&nav=1&start=4&nomax=1&page=1&where=type_#{target_species.upcase},gender_#{gender},age_#{age},breed_#{breed_id}"))
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

      ads.push(Adoptable::Ad.new(name, id, time, breed, photo, url, city, notes))
    end
  end

 end
 ads
end
