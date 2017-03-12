require 'json'
require 'open-uri'
require 'time'
require File.expand_path('../../lib/ad', __FILE__)
require File.expand_path('../../lib/job', __FILE__)

name = "AllPaws"

Adoptable::Job.new(name).run do |target_species, target_breeds, target_exclude_breeds, target_gender, target_age, target_zip, target_distance|
 all_ads = []

 target_breeds.each do |breed|
  # Convert settings to site-specific codes
  distance = target_distance * 1.60934

  species_id =
    # TODO: add all species
    case target_species.downcase
    when 'dog' then 1
    else raise "Unknown species: #{target_species}"
    end

  # document.querySelectorAll('[name=breed_id] option').forEach(function (o) { if (o.getAttribute('value')) { console.log('    when \'' + o.innerText.toLowerCase() + '\' then ' + o.getAttribute('value')); }})
  breed_id = 
    case breed.downcase
    when 'affenpinscher' then 1
    when 'afghan hound' then 2
    when 'airedale terrier' then 3
    when 'akbash' then 4
    when 'akita' then 5
    when 'alaskan klee kai' then 6
    when 'alaskan malamute' then 7
    when 'american bulldog' then 8
    when 'american eskimo dog' then 9
    when 'american foxhound' then 10
    when 'american hairless terrier' then 11
    when 'american pit bull terrier' then 12
    when 'american staffordshire terrier' then 13
    when 'american water spaniel' then 14
    when 'anatolian karabash dog' then 15
    when 'anatolian shepherd' then 16
    when 'appenzell mountain dog' then 17
    when 'argentinian mastiff' then 18
    when 'australian cattle dog/blue heeler' then 19
    when 'australian kelpie' then 20
    when 'australian shepherd' then 21
    when 'australian terrier' then 22
    when 'basenji' then 23
    when 'basset griffon vendeen' then 24
    when 'basset hound' then 25
    when 'beagle' then 26
    when 'bearded collie' then 27
    when 'beauceron' then 28
    when 'bedlington terrier' then 29
    when 'belgian griffon' then 30
    when 'belgian shepherd dog sheepdog' then 31
    when 'belgian shepherd laekenois' then 32
    when 'belgian shepherd malinois' then 33
    when 'belgian shepherd tervuren' then 34
    when 'bernese mountain dog' then 35
    when 'bichon frise' then 36
    when 'biewer' then 37
    when 'black and tan coonhound' then 38
    when 'black labrador retriever' then 39
    when 'black mouth cur' then 40
    when 'black russian terrier' then 41
    when 'bloodhound' then 42
    when 'blue lacy' then 43
    when 'bluetick coonhound' then 44
    when 'bobtail' then 45
    when 'boerboel mastiff' then 46
    when 'bolognese' then 47
    when 'bordeaux' then 48
    when 'border collie' then 49
    when 'border terrier' then 50
    when 'borzoi' then 51
    when 'boston terrier' then 52
    when 'bouvier des flandres' then 53
    when 'boxer' then 54
    when 'boykin spaniel' then 55
    when 'brazilian mastiff' then 56
    when 'briard' then 57
    when 'brittany' then 58
    when 'brussels griffon' then 59
    when 'bull terrier' then 60
    when 'bulldog' then 61
    when 'bullmastiff' then 62
    when 'cairn terrier' then 63
    when 'canaan dog' then 64
    when 'cane corso mastiff' then 65
    when 'cardigan welsh corgi' then 66
    when 'carolina dog' then 67
    when 'catahoula leopard dog' then 68
    when 'cattle dog' then 69
    when 'caucasian sheepdog (caucasian ovtcharka)' then 70
    when 'cavalier king charles spaniel' then 71
    when 'chesapeake bay retriever' then 72
    when 'chihuahua' then 73
    when 'chinese crested-hairless' then 74
    when 'chinese crested-powder puff' then 75
    when 'chinese foo dog' then 76
    when 'chinese shar-pei' then 77
    when 'chinook' then 78
    when 'chocolate labrador retriever' then 79
    when 'chow chow' then 80
    when 'cirneco delletna' then 81
    when 'clumber spaniel' then 82
    when 'cockapoo' then 83
    when 'cocker spaniel' then 84
    when 'collie' then 85
    when 'coonhound' then 86
    when 'corgi' then 87
    when 'coton de tulear' then 88
    when 'curly-coated retriever' then 89
    when 'dachshund' then 90
    when 'dalmatian' then 91
    when 'dandie dinmont terrier' then 92
    when 'danish broholmer' then 93
    when 'deerhound' then 94
    when 'doberman pinscher' then 95
    when 'dogo argentino' then 96
    when 'dogue de bordeaux' then 97
    when 'dutch shepherd' then 98
    when 'elkhound' then 99
    when 'english bulldog' then 100
    when 'english cocker spaniel' then 101
    when 'english coonhound' then 102
    when 'english foxhound' then 103
    when 'english mastiff' then 104
    when 'english pointer' then 105
    when 'english setter' then 106
    when 'english sheepdog' then 107
    when 'english shepherd' then 108
    when 'english springer spaniel' then 109
    when 'english toy spaniel' then 110
    when 'entlebucher' then 111
    when 'eskimo dog' then 112
    when 'eskimo spitz' then 113
    when 'eurasier' then 114
    when 'feist' then 115
    when 'field spaniel' then 116
    when 'fila brasileiro' then 117
    when 'finnish lapphund' then 118
    when 'finnish spitz' then 119
    when 'flat-coated retriever' then 120
    when 'fox terrier' then 121
    when 'foxhound' then 122
    when 'french brittany' then 123
    when 'french bulldog' then 124
    when 'french mastiff' then 125
    when 'galgo spanish greyhound' then 126
    when 'german pinscher' then 127
    when 'german shepherd dog' then 128
    when 'german shorthaired pointer' then 129
    when 'german spitz' then 130
    when 'german wirehaired pointer' then 131
    when 'giant schnauzer' then 132
    when 'glen of imaal terrier' then 133
    when 'golden retriever' then 134
    when 'gordon setter' then 135
    when 'great dane' then 136
    when 'great pyrenees' then 137
    when 'greater swiss mountain dog' then 138
    when 'greyhound' then 139
    when 'halden hound (haldenstrover)' then 140
    when 'harrier' then 141
    when 'havanese' then 142
    when 'hollandse tulphond' then 143
    when 'hound' then 144
    when 'hovawart' then 145
    when 'husky' then 146
    when 'ibizan hound' then 147
    when 'illyrian sheepdog' then 148
    when 'irish setter' then 149
    when 'irish terrier' then 150
    when 'irish water spaniel' then 151
    when 'irish wolfhound' then 152
    when 'italian greyhound' then 153
    when 'italian mastiff' then 154
    when 'italian spinone' then 155
    when 'jack russell terrier' then 156
    when 'jack russell terrier (parson russell terrier)' then 157
    when 'japanese chin' then 158
    when 'jindo (korean)' then 159
    when 'kai dog' then 160
    when 'karelian bear dog' then 161
    when 'keeshond' then 162
    when 'kerry blue terrier' then 163
    when 'kishu' then 164
    when 'klee kai' then 165
    when 'komondor' then 166
    when 'kuvasz' then 167
    when 'kyi leo' then 168
    when 'labrador retriever' then 169
    when 'lakeland terrier' then 170
    when 'lancashire heeler' then 171
    when 'leonberger' then 172
    when 'lhasa apso' then 173
    when 'löwchen' then 174
    when 'maltese' then 175
    when 'manchester terrier' then 176
    when 'maremma sheepdog' then 177
    when 'markiesje' then 178
    when 'mastiff' then 179
    when 'mcnab' then 180
    when 'mexican hairless' then 181
    when 'miniature bull terrier' then 182
    when 'miniature pinscher' then 183
    when 'miniature schnauzer' then 184
    when 'mountain cur' then 185
    when 'mountain dog' then 186
    when 'munsterlander' then 187
    when 'neapolitan mastiff' then 188
    when 'new guinea singing dog' then 189
    when 'newfoundland dog' then 190
    when 'norfolk terrier' then 191
    when 'norwegian buhund' then 192
    when 'norwegian elkhound' then 193
    when 'norwegian lundehund' then 194
    when 'norwich terrier' then 195
    when 'nova scotia duck-tolling retriever' then 196
    when 'old english sheepdog' then 197
    when 'otterhound' then 198
    when 'papillon' then 199
    when 'parson russell terrier' then 200
    when 'patterdale terrier (fell terrier)' then 201
    when 'pekingese' then 202
    when 'pembroke welsh corgi' then 203
    when 'peruvian inca orchid' then 204
    when 'peruvian inca orchid' then 205
    when 'petit basset griffon vendeen' then 206
    when 'pharaoh hound' then 207
    when 'picardy shepherd' then 208
    when 'pit bull terrier' then 209
    when 'plott hound' then 210
    when 'podengo portugueso' then 211
    when 'portuguese podengo' then 211
    when 'portuguese podengo pequeno' then 211
    when 'pointer' then 212
    when 'polish lowland sheepdog' then 213
    when 'pomeranian' then 214
    when 'poodle (miniature)' then 215
    when 'miniature poodle' then 215
    when 'poodle (standard)' then 216
    when 'poodle (t-cup)' then 217
    when 'poodle (toy)' then 218
    when 'toy poodle' then 218
    when 'poodle (unknown type)' then 219
    when 'portuguese water dog' then 220
    when 'presa canario' then 221
    when 'pug' then 222
    when 'puli' then 223
    when 'pumi' then 224
    when 'queensland heeler' then 225
    when 'rat terrier' then 226
    when 'red heeler' then 227
    when 'redbone coonhound' then 228
    when 'retriever' then 229
    when 'rhodesian ridgeback' then 230
    when 'rottweiler' then 231
    when 'russian wolfhound' then 232
    when 'saarlooswolfhond' then 233
    when 'saint bernard' then 234
    when 'saluki' then 235
    when 'saluki greyhound' then 236
    when 'samoyed' then 237
    when 'schiller hound' then 238
    when 'schipperke' then 239
    when 'schnauzer' then 240
    when 'scottish deerhound' then 241
    when 'scottish terrier scottie' then 242
    when 'sealyham terrier' then 243
    when 'setter' then 244
    when 'shar pei' then 245
    when 'sheep dog' then 246
    when 'shepherd' then 247
    when 'shetland sheepdog sheltie' then 248
    when 'shiba inu' then 249
    when 'shih tzu' then 250
    when 'siberian husky' then 251
    when 'silky terrier' then 252
    when 'skye terrier' then 253
    when 'sloughi' then 254
    when 'smooth fox terrier' then 255
    when 'soft-coated wheaten terrier' then 256
    when 'south russian ovcharka' then 257
    when 'spaniel' then 258
    when 'spanish mastiff' then 259
    when 'spinone italiano' then 260
    when 'spitz' then 261
    when 'springer spaniel' then 262
    when 'staffordshire bull terrier' then 263
    when 'sussex spaniel' then 264
    when 'swedish vallhund' then 265
    when 'terrier' then 266
    when 'thai ridgeback' then 267
    when 'tibetan mastiff' then 268
    when 'tibetan spaniel' then 269
    when 'tibetan terrier' then 270
    when 'tosa inu' then 271
    when 'toy fox terrier' then 272
    when 'toy terrier' then 273
    when 'treeing walker coonhound' then 274
    when 'vizsla' then 275
    when 'weimaraner' then 276
    when 'welsh corgi' then 277
    when 'welsh springer spaniel' then 278
    when 'welsh terrier' then 279
    when 'west highland white terrier westie' then 280
    when 'wheaten terrier' then 281
    when 'whippet' then 282
    when 'white german shepherd' then 283
    when 'wire-haired pointing griffon' then 284
    when 'wirehaired fox terrier' then 285
    when 'wolf dog' then 286
    when 'xoloitzcuintle/mexican hairless' then 287
    when 'yellow labrador retriever' then 288
    when 'yorkshire terrier yorkie' then 289
    when 'yorkie' then 289
    when 'yorkshire terrier' then 289
    else raise "Unknown breed: #{breed}"
    end

  gender =
    case target_gender.downcase
    when 'male' then 1
    when 'female' then 2
    else raise "Unknown gender: #{target_gender}"
    end

  age_range =
    # TODO: add all ages
    case target_age.downcase
    when 'puppy' then 1
    else raise "Unknown age: #{target_age}"
    end

  ads = `wget -qO- 'https://www.allpaws.com/search/results?page=1&d=#{distance}&primary_breed_first=1&gender%5B%5D=#{gender}&age_range%5B%5D=#{age_range}&name=&organization_name=&sort=recency&utf8=%E2%9C%93&species_id=#{species_id}&breed_id=#{breed_id}&zip_code=#{target_zip}'`
  ads = JSON.parse(ads)["animals"]
  # TODO: fix time param; there is no date in the ad record?!
  time = Time.now
  notes = ["Date not accurate--not specified in results"]

  ads.reject! { |ad| target_exclude_breeds.any? { |b| !ad["breed"].upcase[b.upcase].nil? } }

  all_ads += ads.map { |ad| Adoptable::Ad.new(name, ad["id"], time -= 24 * 60 * 60, ad["breed"], ad["card_avatar"], "https://www.allpaws.com#{ad["profile_path"]}", ad["location"], notes) }
 end

 all_ads
end
