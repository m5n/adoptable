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

  # document.querySelectorAll('[name=breed] option').forEach(function (o) { if (o.getAttribute('data-akc-code')) { console.log('    when \'' + o.innerText.toLowerCase() + '\' then ' + o.getAttribute('value')); }})
  breed_id = 
    case breed.downcase
    when 'affenpinscher' then 1
    when 'afghan hound' then 2
    when 'airedale terrier' then 3
    when 'akita' then 4
    when 'alaskan malamute' then 5
    when 'american english coonhound' then 6
    when 'american eskimo dog' then 7
    when 'american foxhound' then 9
    when 'american hairless terrier' then 10
    when 'american leopard hound' then 12
    when 'american staffordshire terrier' then 13
    when 'american water spaniel' then 14
    when 'anatolian shepherd dog' then 15
    when 'appenzeller sennenhunde' then 16
    when 'australian cattle dog' then 17
    when 'australian shepherd' then 18
    when 'australian terrier' then 19
    when 'azawakh' then 20
    when 'barbet' then 21
    when 'basenji' then 22
    when 'basset hound' then 23
    when 'beagle' then 24
    when 'bearded collie' then 26
    when 'beauceron' then 27
    when 'bedlington terrier' then 28
    when 'belgian laekenois' then 29
    when 'belgian malinois' then 30
    when 'belgian sheepdog' then 31
    when 'belgian tervuren' then 32
    when 'bergamasco' then 33
    when 'berger picard' then 34
    when 'bernese mountain dog' then 35
    when 'bichon frise' then 265
    when 'biewer terrier' then 269
    when 'black and tan coonhound' then 37
    when 'black russian terrier' then 38
    when 'bloodhound' then 39
    when 'bluetick coonhound' then 40
    when 'boerboel' then 41
    when 'bolognese' then 42
    when 'border collie' then 43
    when 'border terrier' then 44
    when 'borzoi' then 45
    when 'boston terrier' then 46
    when 'bouvier des flandres' then 267
    when 'boxer' then 48
    when 'boykin spaniel' then 49
    when 'bracco italiano' then 50
    when 'braque du bourbonnais' then 51
    when 'briard' then 52
    when 'brittany' then 53
    when 'broholmer' then 54
    when 'brussels griffon' then 55
    when 'bull terrier' then 56
    when 'bulldog' then 57
    when 'bullmastiff' then 58
    when 'cairn terrier' then 59
    when 'canaan dog' then 60
    when 'cane corso' then 61
    when 'cardigan welsh corgi' then 62
    when 'catahoula leopard dog' then 63
    when 'caucasian ovcharka' then 64
    when 'cavalier king charles spaniel' then 65
    when 'central asian shepherd dog' then 66
    when 'cesky terrier' then 67
    when 'chesapeake bay retriever' then 68
    when 'chihuahua' then 69
    when 'chinese crested' then 70
    when 'chinese shar-pei' then 72
    when 'chinook' then 73
    when 'chow chow' then 74
    when 'cirneco dell\'etna' then 75
    when 'clumber spaniel' then 76
    when 'cocker spaniel' then 77
    when 'collie' then 81
    when 'coton de tulear' then 83
    when 'curly-coated retriever' then 84
    when 'czechoslovakian vlcak' then 85
    when 'dachshund' then 263
    when 'dalmatian' then 89
    when 'dandie dinmont terrier' then 90
    when 'danish-swedish farmdog' then 91
    when 'deutscher wachtelhund' then 92
    when 'doberman pinscher' then 93
    when 'dogo argentino' then 94
    when 'dogue de bordeaux' then 95
    when 'drentsche patrijshond' then 96
    when 'drever' then 277
    when 'dutch shepherd' then 97
    when 'english cocker spaniel' then 98
    when 'english foxhound' then 99
    when 'english setter' then 100
    when 'english springer spaniel' then 101
    when 'english toy spaniel' then 102
    when 'entlebucher mountain dog' then 105
    when 'estrela mountain dog' then 107
    when 'eurasier' then 108
    when 'field spaniel' then 109
    when 'finnish lapphund' then 110
    when 'finnish spitz' then 111
    when 'flat-coated retriever' then 112
    when 'french bulldog' then 113
    when 'french spaniel' then 114
    when 'german longhaired pointer' then 115
    when 'german pinscher' then 116
    when 'german shepherd dog' then 117
    when 'german shorthaired pointer' then 118
    when 'german spitz' then 119
    when 'german wirehaired pointer' then 120
    when 'giant schnauzer' then 121
    when 'glen of imaal terrier' then 122
    when 'golden retriever' then 123
    when 'gordon setter' then 124
    when 'grand basset griffon vendeen' then 125
    when 'great dane' then 126
    when 'great pyrenees' then 127
    when 'greater swiss mountain dog' then 128
    when 'greyhound' then 129
    when 'hamiltonstovare' then 130
    when 'harrier' then 131
    when 'havanese' then 132
    when 'hovawart' then 133
    when 'ibizan hound' then 134
    when 'icelandic sheepdog' then 135
    when 'irish red and white setter' then 136
    when 'irish setter' then 137
    when 'irish terrier' then 138
    when 'irish water spaniel' then 139
    when 'irish wolfhound' then 140
    when 'italian greyhound' then 141
    when 'jagdterrier' then 270
    when 'japanese chin' then 142
    when 'jindo' then 143
    when 'kai ken' then 144
    when 'karelian bear dog' then 145
    when 'keeshond' then 266
    when 'kerry blue terrier' then 147
    when 'kishu ken' then 148
    when 'komondor' then 149
    when 'kromfohrlander' then 151
    when 'kuvasz' then 152
    when 'labrador retriever' then 153
    when 'lagotto romagnolo' then 154
    when 'lakeland terrier' then 155
    when 'lancashire heeler' then 156
    when 'leonberger' then 157
    when 'lhasa apso' then 158
    when 'lowchen' then 159
    when 'maltese' then 160
    when 'manchester terrier' then 161
    when 'mastiff' then 163
    when 'miniature american shepherd' then 164
    when 'miniature bull terrier' then 165
    when 'miniature pinscher' then 166
    when 'miniature schnauzer' then 168
    when 'mudi' then 169
    when 'neapolitan mastiff' then 170
    when 'nederlandse kooikerhondje' then 150
    when 'newfoundland' then 171
    when 'norfolk terrier' then 172
    when 'norrbottenspets' then 173
    when 'norwegian buhund' then 174
    when 'norwegian elkhound' then 175
    when 'norwegian lundehund' then 176
    when 'norwich terrier' then 177
    when 'nova scotia duck tolling retriever' then 178
    when 'old english sheepdog' then 179
    when 'otterhound' then 180
    when 'papillon' then 181
    when 'parson russell terrier' then 182
    when 'pekingese' then 183
    when 'pembroke welsh corgi' then 184
    when 'perro de presa canario' then 185
    when 'peruvian inca orchid' then 186
    when 'petit basset griffon vendeen' then 264
    when 'pharaoh hound' then 189
    when 'plott' then 190
    when 'pointer' then 191
    when 'polish lowland sheepdog' then 192
    when 'pomeranian' then 193
    when 'poodle' then 194
    when 'miniature poodle' then 194
    when 'toy poodle' then 194
    when 'portuguese podengo' then 197
    when 'portuguese podengo pequeno' then 198
    when 'portuguese pointer' then 199
    when 'portuguese sheepdog' then 200
    when 'portuguese water dog' then 201
    when 'pug' then 202
    when 'puli' then 203
    when 'pumi' then 268
    when 'pyrenean mastiff' then 272
    when 'pyrenean shepherd' then 204
    when 'rafeiro do alentejo' then 205
    when 'rat terrier' then 206
    when 'redbone coonhound' then 207
    when 'rhodesian ridgeback' then 208
    when 'rottweiler' then 209
    when 'russell terrier' then 210
    when 'russian toy' then 211
    when 'russian tsvetnaya bolonka' then 278
    when 'saluki' then 212
    when 'samoyed' then 213
    when 'schapendoes' then 214
    when 'schipperke' then 215
    when 'scottish deerhound' then 216
    when 'scottish terrier' then 217
    when 'sealyham terrier' then 218
    when 'shetland sheepdog' then 219
    when 'shiba inu' then 220
    when 'shih tzu' then 221
    when 'shikoku' then 273
    when 'siberian husky' then 222
    when 'silky terrier' then 223
    when 'skye terrier' then 224
    when 'sloughi' then 225
    when 'slovensky cuvac' then 226
    when 'small munsterlander pointer' then 227
    when 'smooth fox terrier' then 228
    when 'soft coated wheaten terrier' then 229
    when 'spanish mastiff' then 230
    when 'spanish water dog' then 231
    when 'spinone italiano' then 262
    when 'st. bernard' then 233
    when 'stabyhoun' then 234
    when 'staffordshire bull terrier' then 235
    when 'standard schnauzer' then 236
    when 'sussex spaniel' then 237
    when 'swedish lapphund' then 238
    when 'swedish vallhund' then 239
    when 'thai ridgeback' then 240
    when 'tibetan mastiff' then 241
    when 'tibetan spaniel' then 242
    when 'tibetan terrier' then 243
    when 'tornjak' then 244
    when 'tosa' then 245
    when 'toy fox terrier' then 246
    when 'treeing tennessee brindle' then 274
    when 'treeing walker coonhound' then 248
    when 'vizsla' then 249
    when 'weimaraner' then 250
    when 'welsh springer spaniel' then 251
    when 'welsh terrier' then 252
    when 'west highland white terrier' then 253
    when 'whippet' then 254
    when 'wire fox terrier' then 255
    when 'wirehaired pointing griffon' then 256
    when 'wirehaired vizsla' then 257
    when 'working kelpie' then 275
    when 'xoloitzcuintli' then 259
    when 'yorkie' then 260
    when 'yorkshire terrier' then 260
    else raise "Unknown breed: #{breed}"
    end

  # document.querySelectorAll('[name=breed] option').forEach(function (o) { if (o.getAttribute('data-akc-code')) { console.log('    when \'' + o.innerText.toLowerCase() + '\' then \'' + o.innerText.toLowerCase().replace(/ /g, '-') + '\''); }})
  breed_name = 
    case breed.downcase
    when 'affenpinscher' then 'affenpinscher'
    when 'afghan hound' then 'afghan-hound'
    when 'airedale terrier' then 'airedale-terrier'
    when 'akita' then 'akita'
    when 'alaskan malamute' then 'alaskan-malamute'
    when 'american english coonhound' then 'american-english-coonhound'
    when 'american eskimo dog' then 'american-eskimo-dog'
    when 'american foxhound' then 'american-foxhound'
    when 'american hairless terrier' then 'american-hairless-terrier'
    when 'american leopard hound' then 'american-leopard-hound'
    when 'american staffordshire terrier' then 'american-staffordshire-terrier'
    when 'american water spaniel' then 'american-water-spaniel'
    when 'anatolian shepherd dog' then 'anatolian-shepherd-dog'
    when 'appenzeller sennenhunde' then 'appenzeller-sennenhunde'
    when 'australian cattle dog' then 'australian-cattle-dog'
    when 'australian shepherd' then 'australian-shepherd'
    when 'australian terrier' then 'australian-terrier'
    when 'azawakh' then 'azawakh'
    when 'barbet' then 'barbet'
    when 'basenji' then 'basenji'
    when 'basset hound' then 'basset-hound'
    when 'beagle' then 'beagle'
    when 'bearded collie' then 'bearded-collie'
    when 'beauceron' then 'beauceron'
    when 'bedlington terrier' then 'bedlington-terrier'
    when 'belgian laekenois' then 'belgian-laekenois'
    when 'belgian malinois' then 'belgian-malinois'
    when 'belgian sheepdog' then 'belgian-sheepdog'
    when 'belgian tervuren' then 'belgian-tervuren'
    when 'bergamasco' then 'bergamasco'
    when 'berger picard' then 'berger-picard'
    when 'bernese mountain dog' then 'bernese-mountain-dog'
    when 'bichon frise' then 'bichon-frise'
    when 'biewer terrier' then 'biewer-terrier'
    when 'black and tan coonhound' then 'black-and-tan-coonhound'
    when 'black russian terrier' then 'black-russian-terrier'
    when 'bloodhound' then 'bloodhound'
    when 'bluetick coonhound' then 'bluetick-coonhound'
    when 'boerboel' then 'boerboel'
    when 'bolognese' then 'bolognese'
    when 'border collie' then 'border-collie'
    when 'border terrier' then 'border-terrier'
    when 'borzoi' then 'borzoi'
    when 'boston terrier' then 'boston-terrier'
    when 'bouvier des flandres' then 'bouvier-des-flandres'
    when 'boxer' then 'boxer'
    when 'boykin spaniel' then 'boykin-spaniel'
    when 'bracco italiano' then 'bracco-italiano'
    when 'braque du bourbonnais' then 'braque-du-bourbonnais'
    when 'briard' then 'briard'
    when 'brittany' then 'brittany'
    when 'broholmer' then 'broholmer'
    when 'brussels griffon' then 'brussels-griffon'
    when 'bull terrier' then 'bull-terrier'
    when 'bulldog' then 'bulldog'
    when 'bullmastiff' then 'bullmastiff'
    when 'cairn terrier' then 'cairn-terrier'
    when 'canaan dog' then 'canaan-dog'
    when 'cane corso' then 'cane-corso'
    when 'cardigan welsh corgi' then 'cardigan-welsh-corgi'
    when 'catahoula leopard dog' then 'catahoula-leopard-dog'
    when 'caucasian ovcharka' then 'caucasian-ovcharka'
    when 'cavalier king charles spaniel' then 'cavalier-king-charles-spaniel'
    when 'central asian shepherd dog' then 'central-asian-shepherd-dog'
    when 'cesky terrier' then 'cesky-terrier'
    when 'chesapeake bay retriever' then 'chesapeake-bay-retriever'
    when 'chihuahua' then 'chihuahua'
    when 'chinese crested' then 'chinese-crested'
    when 'chinese shar-pei' then 'chinese-shar-pei'
    when 'chinook' then 'chinook'
    when 'chow chow' then 'chow-chow'
    when 'cirneco dell\'etna' then 'cirneco-dell\'etna'
    when 'clumber spaniel' then 'clumber-spaniel'
    when 'cocker spaniel' then 'cocker-spaniel'
    when 'collie' then 'collie'
    when 'coton de tulear' then 'coton-de-tulear'
    when 'curly-coated retriever' then 'curly-coated-retriever'
    when 'czechoslovakian vlcak' then 'czechoslovakian-vlcak'
    when 'dachshund' then 'dachshund'
    when 'dalmatian' then 'dalmatian'
    when 'dandie dinmont terrier' then 'dandie-dinmont-terrier'
    when 'danish-swedish farmdog' then 'danish-swedish-farmdog'
    when 'deutscher wachtelhund' then 'deutscher-wachtelhund'
    when 'doberman pinscher' then 'doberman-pinscher'
    when 'dogo argentino' then 'dogo-argentino'
    when 'dogue de bordeaux' then 'dogue-de-bordeaux'
    when 'drentsche patrijshond' then 'drentsche-patrijshond'
    when 'drever' then 'drever'
    when 'dutch shepherd' then 'dutch-shepherd'
    when 'english cocker spaniel' then 'english-cocker-spaniel'
    when 'english foxhound' then 'english-foxhound'
    when 'english setter' then 'english-setter'
    when 'english springer spaniel' then 'english-springer-spaniel'
    when 'english toy spaniel' then 'english-toy-spaniel'
    when 'entlebucher mountain dog' then 'entlebucher-mountain-dog'
    when 'estrela mountain dog' then 'estrela-mountain-dog'
    when 'eurasier' then 'eurasier'
    when 'field spaniel' then 'field-spaniel'
    when 'finnish lapphund' then 'finnish-lapphund'
    when 'finnish spitz' then 'finnish-spitz'
    when 'flat-coated retriever' then 'flat-coated-retriever'
    when 'french bulldog' then 'french-bulldog'
    when 'french spaniel' then 'french-spaniel'
    when 'german longhaired pointer' then 'german-longhaired-pointer'
    when 'german pinscher' then 'german-pinscher'
    when 'german shepherd dog' then 'german-shepherd-dog'
    when 'german shorthaired pointer' then 'german-shorthaired-pointer'
    when 'german spitz' then 'german-spitz'
    when 'german wirehaired pointer' then 'german-wirehaired-pointer'
    when 'giant schnauzer' then 'giant-schnauzer'
    when 'glen of imaal terrier' then 'glen-of-imaal-terrier'
    when 'golden retriever' then 'golden-retriever'
    when 'gordon setter' then 'gordon-setter'
    when 'grand basset griffon vendeen' then 'grand-basset-griffon-vendeen'
    when 'great dane' then 'great-dane'
    when 'great pyrenees' then 'great-pyrenees'
    when 'greater swiss mountain dog' then 'greater-swiss-mountain-dog'
    when 'greyhound' then 'greyhound'
    when 'hamiltonstovare' then 'hamiltonstovare'
    when 'harrier' then 'harrier'
    when 'havanese' then 'havanese'
    when 'hovawart' then 'hovawart'
    when 'ibizan hound' then 'ibizan-hound'
    when 'icelandic sheepdog' then 'icelandic-sheepdog'
    when 'irish red and white setter' then 'irish-red-and-white-setter'
    when 'irish setter' then 'irish-setter'
    when 'irish terrier' then 'irish-terrier'
    when 'irish water spaniel' then 'irish-water-spaniel'
    when 'irish wolfhound' then 'irish-wolfhound'
    when 'italian greyhound' then 'italian-greyhound'
    when 'jagdterrier' then 'jagdterrier'
    when 'japanese chin' then 'japanese-chin'
    when 'jindo' then 'jindo'
    when 'kai ken' then 'kai-ken'
    when 'karelian bear dog' then 'karelian-bear-dog'
    when 'keeshond' then 'keeshond'
    when 'kerry blue terrier' then 'kerry-blue-terrier'
    when 'kishu ken' then 'kishu-ken'
    when 'komondor' then 'komondor'
    when 'kromfohrlander' then 'kromfohrlander'
    when 'kuvasz' then 'kuvasz'
    when 'labrador retriever' then 'labrador-retriever'
    when 'lagotto romagnolo' then 'lagotto-romagnolo'
    when 'lakeland terrier' then 'lakeland-terrier'
    when 'lancashire heeler' then 'lancashire-heeler'
    when 'leonberger' then 'leonberger'
    when 'lhasa apso' then 'lhasa-apso'
    when 'lowchen' then 'lowchen'
    when 'maltese' then 'maltese'
    when 'manchester terrier' then 'manchester-terrier'
    when 'mastiff' then 'mastiff'
    when 'miniature american shepherd' then 'miniature-american-shepherd'
    when 'miniature bull terrier' then 'miniature-bull-terrier'
    when 'miniature pinscher' then 'miniature-pinscher'
    when 'miniature schnauzer' then 'miniature-schnauzer'
    when 'mudi' then 'mudi'
    when 'neapolitan mastiff' then 'neapolitan-mastiff'
    when 'nederlandse kooikerhondje' then 'nederlandse-kooikerhondje'
    when 'newfoundland' then 'newfoundland'
    when 'norfolk terrier' then 'norfolk-terrier'
    when 'norrbottenspets' then 'norrbottenspets'
    when 'norwegian buhund' then 'norwegian-buhund'
    when 'norwegian elkhound' then 'norwegian-elkhound'
    when 'norwegian lundehund' then 'norwegian-lundehund'
    when 'norwich terrier' then 'norwich-terrier'
    when 'nova scotia duck tolling retriever' then 'nova-scotia-duck-tolling-retriever'
    when 'old english sheepdog' then 'old-english-sheepdog'
    when 'otterhound' then 'otterhound'
    when 'papillon' then 'papillon'
    when 'parson russell terrier' then 'parson-russell-terrier'
    when 'pekingese' then 'pekingese'
    when 'pembroke welsh corgi' then 'pembroke-welsh-corgi'
    when 'perro de presa canario' then 'perro-de-presa-canario'
    when 'peruvian inca orchid' then 'peruvian-inca-orchid'
    when 'petit basset griffon vendeen' then 'petit-basset-griffon-vendeen'
    when 'pharaoh hound' then 'pharaoh-hound'
    when 'plott' then 'plott'
    when 'pointer' then 'pointer'
    when 'polish lowland sheepdog' then 'polish-lowland-sheepdog'
    when 'pomeranian' then 'pomeranian'
    when 'poodle' then 'poodle'
    when 'miniature poodle' then 'poodle'
    when 'toy poodle' then 'poodle'
    when 'portuguese podengo' then 'portuguese-podengo'
    when 'portuguese podengo pequeno' then 'portuguese-podengo-pequeno'
    when 'portuguese pointer' then 'portuguese-pointer'
    when 'portuguese sheepdog' then 'portuguese-sheepdog'
    when 'portuguese water dog' then 'portuguese-water-dog'
    when 'pug' then 'pug'
    when 'puli' then 'puli'
    when 'pumi' then 'pumi'
    when 'pyrenean mastiff' then 'pyrenean-mastiff'
    when 'pyrenean shepherd' then 'pyrenean-shepherd'
    when 'rafeiro do alentejo' then 'rafeiro-do-alentejo'
    when 'rat terrier' then 'rat-terrier'
    when 'redbone coonhound' then 'redbone-coonhound'
    when 'rhodesian ridgeback' then 'rhodesian-ridgeback'
    when 'rottweiler' then 'rottweiler'
    when 'russell terrier' then 'russell-terrier'
    when 'russian toy' then 'russian-toy'
    when 'russian tsvetnaya bolonka' then 'russian-tsvetnaya-bolonka'
    when 'saluki' then 'saluki'
    when 'samoyed' then 'samoyed'
    when 'schapendoes' then 'schapendoes'
    when 'schipperke' then 'schipperke'
    when 'scottish deerhound' then 'scottish-deerhound'
    when 'scottish terrier' then 'scottish-terrier'
    when 'sealyham terrier' then 'sealyham-terrier'
    when 'shetland sheepdog' then 'shetland-sheepdog'
    when 'shiba inu' then 'shiba-inu'
    when 'shih tzu' then 'shih-tzu'
    when 'shikoku' then 'shikoku'
    when 'siberian husky' then 'siberian-husky'
    when 'silky terrier' then 'silky-terrier'
    when 'skye terrier' then 'skye-terrier'
    when 'sloughi' then 'sloughi'
    when 'slovensky cuvac' then 'slovensky-cuvac'
    when 'small munsterlander pointer' then 'small-munsterlander-pointer'
    when 'smooth fox terrier' then 'smooth-fox-terrier'
    when 'soft coated wheaten terrier' then 'soft-coated-wheaten-terrier'
    when 'spanish mastiff' then 'spanish-mastiff'
    when 'spanish water dog' then 'spanish-water-dog'
    when 'spinone italiano' then 'spinone-italiano'
    when 'st. bernard' then 'st.-bernard'
    when 'stabyhoun' then 'stabyhoun'
    when 'staffordshire bull terrier' then 'staffordshire-bull-terrier'
    when 'standard schnauzer' then 'standard-schnauzer'
    when 'sussex spaniel' then 'sussex-spaniel'
    when 'swedish lapphund' then 'swedish-lapphund'
    when 'swedish vallhund' then 'swedish-vallhund'
    when 'thai ridgeback' then 'thai-ridgeback'
    when 'tibetan mastiff' then 'tibetan-mastiff'
    when 'tibetan spaniel' then 'tibetan-spaniel'
    when 'tibetan terrier' then 'tibetan-terrier'
    when 'tornjak' then 'tornjak'
    when 'tosa' then 'tosa'
    when 'toy fox terrier' then 'toy-fox-terrier'
    when 'treeing tennessee brindle' then 'treeing-tennessee-brindle'
    when 'treeing walker coonhound' then 'treeing-walker-coonhound'
    when 'vizsla' then 'vizsla'
    when 'weimaraner' then 'weimaraner'
    when 'welsh springer spaniel' then 'welsh-springer-spaniel'
    when 'welsh terrier' then 'welsh-terrier'
    when 'west highland white terrier' then 'west-highland-white-terrier'
    when 'whippet' then 'whippet'
    when 'wire fox terrier' then 'wire-fox-terrier'
    when 'wirehaired pointing griffon' then 'wirehaired-pointing-griffon'
    when 'wirehaired vizsla' then 'wirehaired-vizsla'
    when 'working kelpie' then 'working-kelpie'
    when 'xoloitzcuintli' then 'xoloitzcuintli'
    when 'yorkie' then 'yorkshire-terrier'
    when 'yorkshire terrier' then 'yorkshire-terrier'
    else raise "Unknown breed: #{breed}"
    end

  doc = Nokogiri::HTML(open("http://marketplace.akc.org/puppies/#{breed_name}?breed=#{breed_id}&gender=#{target_gender.downcase}&location=#{target_zip}&radius=#{target_distance}"))
  doc.css('.litter-card a').each do |elt|
    # Avoid rate limiting
    # Also do first time because we just got the shelters
    sleep(5)

    breeder = elt.css('.litter-card__info')[1].text.strip
    city = elt.css('.litter-card__info')[2].text.gsub(/ ?\d+$/, '').strip

    url = "http://marketplace.akc.org#{elt.attr('href')}"
    doc = Nokogiri::HTML(open(url))

    # Sometimes the breeder URL no longer resolves, so the home page is returned, e.g.
    # http://marketplace.akc.org/heidi-shepard-39458/poodle-77058
    next if doc.css('.storefront').empty?

    # Avoid "no _dump_data is defined for class Nokogiri::XML::Attr" error by converting attr() to string in various places
    id = doc.css('.storefront').attr('data-storefront-id').to_s

    doc.css('.listing-details').each do |elt|
      photo = /url\('?(.+?)\'?\)/.match(elt.css('.js-listing-details-image')[0].attr('style'))[1]
      ad_breed = elt.css('.listing-details__main ul li a')[0].text
      #dob = elt.css('.listing-details__main ul li')[1].text[5..-1]
      #time = Time.strptime(dob, "%m/%d/%Y")
      time = elt.css('.listing-details__misc small')[0].text[15..-1]
      notes = nil
      begin
        # Could be format Jan, 2017
        time = Time.strptime(time, "%b, %Y")
      rescue
        begin
          # Could also be format Fri Oct 28th, 2016
          time = time.sub('st', '').sub('nd', '').sub('rd', '').sub('th', '')
          time = Time.strptime(time, "%a %b %d, %Y")
        rescue
          p "ERROR: #{name}: Could not parse publish date: #{time}--falling back to \"now\""
          time = Time.now
        end
      end

      # Puppies of all breeds this breeders breeds are listed
      #if !ad_breed.downcase[breed.downcase].nil? then
        ads.push(Adoptable::Ad.new("#{name} - #{breeder}", id, time, ad_breed, photo, url, city))
      #end
    end
  end
 end

 ads
end
