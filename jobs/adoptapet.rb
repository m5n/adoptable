require 'json'
require 'nokogiri'
require 'open-uri'
require 'time'
require File.expand_path('../../lib/ad', __FILE__)
require File.expand_path('../../lib/job', __FILE__)

name = "Adopt a Pet"

Adoptable::Job.new(name).run do |target_species, target_breeds, target_exclude_breeds, target_gender, target_age, target_zip, target_distance|
 ads = []

 target_breeds.each do |breed|
  # Convert settings to site-specific codes
  # TODO: do this rather than capitalize
  species_id =
    # TODO: add all species
    case target_species.downcase
    when 'dog' then 1
    else raise "Unknown species: #{target_species}"
    end

  breed_id = 
    # TODO: add all breeds
    case breed.downcase
    when 'havanese' then 501
    when 'maltese' then 77
    when 'yorkie' then 244
    when 'yorkshire' then 244
    else raise "Unknown breed: #{breed}"
    end
=begin
                                            <option value="real=187|Affenpinscher">
                                            <option value="real=1|Afghan Hound">
                                            <option value="real=2|Airedale Terrier">
                                            <option value="real=800|Akbash">
                                            <option value="real=3|Akita">
                                            <option value="real=4|Alaskan Malamute">
                                            <option value="real=361|American Bulldog">
                                            <option value="real=5|American Eskimo Dog">
                                            <option value="real=1167|American Hairless Terrier">
                                            <option value="real=801|American Pit Bull Terrier">
                                            <option value="real=1082|American Staffordshire Terrier">
                                            <option value="nick=1030|American Water Spaniel">
                                            <option value="real=7|Anatolian Shepherd">
                                            <option value="real=8|Australian Cattle Dog">
                                            <option value="real=9|Australian Kelpie">
                                            <option value="real=10|Australian Shepherd">
                                            <option value="real=802|Australian Terrier">
                                            <option value="real=12|Basenji">
                                            <option value="nick=1053|Basset Griffon Vendeen">
                                            <option value="real=13|Basset Hound">
                                            <option value="real=14|Beagle">
                                            <option value="real=15|Bearded Collie">
                                            <option value="real=803|Beauceron">
                                            <option value="real=189|Bedlington Terrier">
                                            <option value="real=1168|Belgian Laekenois">
                                            <option value="real=191|Belgian Malinois">
                                            <option value="real=16|Belgian Shepherd">
                                            <option value="real=192|Belgian Tervuren">
                                            <option value="real=17|Bernese Mountain Dog">
                                            <option value="real=18|Bichon Frise">
                                            <option value="real=804|Black Mouth Cur">
                                            <option value="real=19|Black and Tan Coonhound">
                                            <option value="real=20|Bloodhound">
                                            <option value="nick=1027|Blue Heeler">
                                            <option value="real=1368|Blue Lacy/Texas Lacy">
                                            <option value="real=193|Bluetick Coonhound">
                                            <option value="nick=1041|Bobtail">
                                            <option value="real=1165|Bolognese">
                                            <option value="real=21|Border Collie">
                                            <option value="real=194|Border Terrier">
                                            <option value="real=22|Borzoi">
                                            <option value="real=23|Boston Terrier">
                                            <option value="real=24|Bouvier des Flandres">
                                            <option value="real=25|Boxer">
                                            <option value="real=601|Boykin Spaniel">
                                            <option value="real=26|Briard">
                                            <option value="real=27|Brittany">
                                            <option value="real=195|Brussels Griffon">
                                            <option value="real=28|Bull Terrier">
                                            <option value="nick=1039|Bulldog">
                                            <option value="real=30|Bullmastiff">
                                            <option value="real=31|Cairn Terrier">
                                            <option value="real=381|Canaan Dog">
                                            <option value="nick=1194|Canary Dog">
                                            <option value="real=461|Cane Corso">
                                            <option value="nick=1036|Cardigan Welsh Corgi">
                                            <option value="real=805|Carolina Dog">
                                            <option value="real=33|Catahoula Leopard Dog">
                                            <option value="nick=1028|Cattle Dog">
                                            <option value="real=34|Cavalier King Charles Spaniel">
                                            <option value="real=35|Chesapeake Bay Retriever">
                                            <option value="real=36|Chihuahua">
                                            <option value="real=37|Chinese Crested">
                                            <option value="real=38|Chow Chow">
                                            <option value="real=196|Clumber Spaniel">
                                            <option value="real=39|Cockapoo">
                                            <option value="real=40|Cocker Spaniel">
                                            <option value="real=41|Collie">
                                            <option value="real=42|Coonhound">
                                            <option value="real=230|Corgi">
                                            <option value="real=521|Coton de Tulear">
                                            <option value="real=1169|Curly-Coated Retriever">
                                            <option value="real=44|Dachshund">
                                            <option value="real=45|Dalmatian">
                                            <option value="real=199|Dandie Dinmont Terrier">
                                            <option value="nick=1060|Deerhound">
                                            <option value="real=46|Doberman Pinscher">
                                            <option value="real=621|Dogo Argentino">
                                            <option value="real=242|Dogue de Bordeaux">
                                            <option value="real=47|Dutch Shepherd">
                                            <option value="real=1186|English (Redtick) Coonhound">
                                            <option value="real=29|English Bulldog">
                                            <option value="nick=1052|English Mastiff">
                                            <option value="nick=1173|English Pointer">
                                            <option value="real=49|English Setter">
                                            <option value="nick=1042|English Sheepdog">
                                            <option value="real=641|English Shepherd">
                                            <option value="real=51|English Springer Spaniel">
                                            <option value="real=52|English Toy Spaniel">
                                            <option value="real=808|Entlebucher">
                                            <option value="nick=1020|Eskimo Dog">
                                            <option value="nick=1019|Eskimo Spitz">
                                            <option value="real=310|Feist">
                                            <option value="real=201|Field Spaniel">
                                            <option value="real=810|Fila Brasileiro">
                                            <option value="real=811|Finnish Lapphund">
                                            <option value="real=54|Finnish Spitz">
                                            <option value="real=202|Flat-Coated Retriever">
                                            <option value="real=812|Fox Terrier (Smooth)">
                                            <option value="real=813|Fox Terrier (Toy)">
                                            <option value="real=55|Fox Terrier (Wirehaired)">
                                            <option value="real=56|Foxhound">
                                            <option value="real=203|French Bulldog">
                                            <option value="nick=1038|French Mastiff">
                                            <option value="real=814|German Pinscher">
                                            <option value="real=57|German Shepherd Dog">
                                            <option value="real=58|German Shorthaired Pointer">
                                            <option value="real=204|German Wirehaired Pointer">
                                            <option value="nick=1171|Giant Schnauzer">
                                            <option value="real=815|Glen of Imaal Terrier">
                                            <option value="real=60|Golden Retriever">
                                            <option value="real=1369|Goldendoodle">
                                            <option value="real=61|Gordon Setter">
                                            <option value="real=62|Great Dane">
                                            <option value="real=63|Great Pyrenees">
                                            <option value="real=205|Greater Swiss Mountain Dog">
                                            <option value="real=64|Greyhound">
                                            <option value="real=661|Halden Hound (Haldenstrover)">
                                            <option value="real=206|Harrier">
                                            <option value="real=501|Havanese">
                                            <option value="real=816|Hovawart">
                                            <option value="nick=1195|Hungarian Puli">
                                            <option value="nick=1196|Hungarian Water Dog">
                                            <option value="real=817|Husky">
                                            <option value="real=281|Ibizan Hound">
                                            <option value="real=67|Irish Setter">
                                            <option value="real=207|Irish Terrier">
                                            <option value="real=208|Irish Water Spaniel">
                                            <option value="real=68|Irish Wolfhound">
                                            <option value="real=69|Italian Greyhound">
                                            <option value="real=818|Italian Spinone">
                                            <option value="real=70|Jack Russell Terrier">
                                            <option value="real=71|Japanese Chin">
                                            <option value="real=72|Jindo">
                                            <option value="real=819|Kai Dog">
                                            <option value="real=820|Karelian Bear Dog">
                                            <option value="real=73|Keeshond">
                                            <option value="real=209|Kerry Blue Terrier">
                                            <option value="nick=1032|King Charles Spaniel">
                                            <option value="real=821|Kishu">
                                            <option value="real=210|Komondor">
                                            <option value="real=74|Kuvasz">
                                            <option value="real=822|Kyi Leo">
                                            <option value="real=1170|Labradoodle">
                                            <option value="real=823|Labrador Retriever">
                                            <option value="real=211|Lakeland Terrier">
                                            <option value="real=826|Lancashire Heeler">
                                            <option value="nick=1034|&quot;Lassie's Friends!&quot;">
                                            <option value="real=827|Leonberger">
                                            <option value="real=76|Lhasa Apso">
                                            <option value="real=1187|Löwchen">
                                            <option value="real=77|Maltese">
                                            <option value="real=78|Manchester Terrier">
                                            <option value="real=828|Maremma Sheepdog">
                                            <option value="real=200|Mastiff">
                                            <option value="nick=1061|Mexican Hairless">
                                            <option value="real=80|Miniature Pinscher">
                                            <option value="nick=1054|Miniature Poodle">
                                            <option value="nick=1058|Miniature Schnauzer">
                                            <option value="real=829|Mountain Cur">
                                            <option value="real=830|Munsterlander">
                                            <option value="nick=1026|&quot;Muscle-Bound Momma's Boys (&amp; Girls!)&quot;">
                                            <option value="real=83|Neapolitan Mastiff">
                                            <option value="real=84|Newfoundland">
                                            <option value="real=214|Norfolk Terrier">
                                            <option value="real=831|Norwegian Buhund">
                                            <option value="real=85|Norwegian Elkhound">
                                            <option value="real=215|Norwich Terrier">
                                            <option value="real=832|Nova Scotia Duck-Tolling Retriever">
                                            <option value="real=302|Old English Sheepdog">
                                            <option value="real=87|Otterhound">
                                            <option value="real=88|Papillon">
                                            <option value="nick=1172|Parson Russell Terrier">
                                            <option value="real=833|Patterdale Terrier (Fell Terrier)">
                                            <option value="real=89|Pekingese">
                                            <option value="nick=1035|Pembroke Welsh Corgi">
                                            <option value="real=216|Petit Basset Griffon Vendeen">
                                            <option value="real=90|Pharaoh Hound">
                                            <option value="nick=1021|Pit Bull Terrier">
                                            <option value="real=581|Plott Hound">
                                            <option value="real=834|Podengo Portugueso">
                                            <option value="real=92|Pointer">
                                            <option value="real=1166|Polish Lowland Sheepdog">
                                            <option value="real=93|Pomeranian">
                                            <option value="real=213|Poodle (Miniature)">
                                            <option value="real=94|Poodle (Standard)">
                                            <option value="real=226|Poodle (Toy or Tea Cup)">
                                            <option value="real=95|Portuguese Water Dog">
                                            <option value="real=1188|Presa Canario">
                                            <option value="real=96|Pug">
                                            <option value="real=1189|Puli">
                                            <option value="real=835|Pumi">
                                            <option value="real=218|Rat Terrier">
                                            <option value="real=664|Redbone Coonhound">
                                            <option value="nick=1193|Redtick Coonhound">
                                            <option value="real=98|Rhodesian Ridgeback">
                                            <option value="real=99|Rottweiler">
                                            <option value="nick=1029|Russian Wolfhound">
                                            <option value="real=101|Saluki">
                                            <option value="real=102|Samoyed">
                                            <option value="real=662|Schiller Hound">
                                            <option value="real=103|Schipperke">
                                            <option value="real=836|Schnauzer (Giant)">
                                            <option value="real=837|Schnauzer (Miniature)">
                                            <option value="real=104|Schnauzer (Standard)">
                                            <option value="real=105|Scottie, Scottish Terrier">
                                            <option value="real=219|Scottish Deerhound">
                                            <option value="real=220|Sealyham Terrier">
                                            <option value="real=107|Shar Pei">
                                            <option value="real=108|Sheltie, Shetland Sheepdog">
                                            <option value="real=110|Shiba Inu">
                                            <option value="real=111|Shih Tzu">
                                            <option value="nick=1084|Siberian Husky">
                                            <option value="real=113|Silky Terrier">
                                            <option value="real=221|Skye Terrier">
                                            <option value="real=841|Sloughi">
                                            <option value="nick=1044|Smooth Fox Terrier">
                                            <option value="nick=1043|Springer Spaniel">
                                            <option value="real=100|St. Bernard">
                                            <option value="nick=1022|Staffordshire Bull Terrier">
                                            <option value="nick=1055|Standard Poodle">
                                            <option value="nick=1059|Standard Schnauzer">
                                            <option value="nick=1024|&quot;Strong but Sweet&quot;">
                                            <option value="real=222|Sussex Spaniel">
                                            <option value="real=846|Swedish Vallhund">
                                            <option value="nick=1057|Tea Cup Poodle">
                                            <option value="real=561|Thai Ridgeback">
                                            <option value="real=224|Tibetan Mastiff">
                                            <option value="real=225|Tibetan Spaniel">
                                            <option value="real=118|Tibetan Terrier">
                                            <option value="real=848|Tosa Inu">
                                            <option value="nick=1056|Toy Poodle">
                                            <option value="real=119|Treeing Walker Coonhound">
                                            <option value="real=120|Vizsla">
                                            <option value="real=121|Weimaraner">
                                            <option value="nick=1037|Welsh Corgi">
                                            <option value="real=849|Welsh Springer Spaniel">
                                            <option value="real=227|Welsh Terrier">
                                            <option value="real=123|Westie, West Highland White Terrier">
                                            <option value="real=124|Wheaten Terrier">
                                            <option value="real=125|Whippet">
                                            <option value="nick=1045|Wirehaired Fox Terrier">
                                            <option value="real=127|Wirehaired Pointing Griffon">
                                            <option value="real=212|Xoloitzcuintle/Mexican Hairless">
                                            <option value="real=244|Yorkie, Yorkshire Terrier">
=end
  gender = target_gender.downcase[0, 1]

  doc = Nokogiri::HTML(open("http://www.adoptapet.com/#{target_species.downcase}-adoption/search/#{target_distance}/miles/#{target_zip}?family_name=#{breed.capitalize}&age=#{target_age.downcase}&sex=#{gender}&family_id=#{breed_id}"))

  # A page with matches will have 2 headers: one between results and "These are not what you asked for but are close" and another for "Here are some others in your area"
  # A page without matches will only have the second header
  next if doc.css('.results_wrapper .row_heading').length < 2

  time = Time.now
  # Page source has matching and non-matching results, separated by a "row heading"
  doc.css('.results_wrapper div').each do |elt|
    # Process results until the row heading is encountered
    break if elt.attr('class')['row_heading']

    url = elt.css('a')[0].attr('href')
    id = /\/pet\/(\d+)/.match(url)[1]
    city = elt.css('a')[2].text
    img_src = elt.css('img')[0]
    photo = img_src.attr('src') if !img_src.nil?

    # TODO: fix time param; there is no date in the ad record?!
    notes = ["Date not accurate--not specified in results"]

    # Breed/Mix not available on results page so cannot remove unwanted breeds in mix

    ads.push(Adoptable::Ad.new(name, id, time -= 24 * 60 * 60, photo, url, city, notes))
  end
 end

 ads
end
