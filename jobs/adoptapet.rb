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

  # document.querySelectorAll('[name=family_id] option').forEach(function (o) { if (o.value.startsWith('real')) { var parts = o.value.split('|'); console.log('    when \'' + parts[1].toLowerCase() + '\' then ' + parts[0].substring(5)); }})
  family_id = 
    case breed.downcase
    when 'affenpinscher' then 187
    when 'afghan hound' then 1
    when 'airedale terrier' then 2
    when 'akbash' then 800
    when 'akita' then 3
    when 'alaskan malamute' then 4
    when 'american bulldog' then 361
    when 'american eskimo dog' then 5
    when 'american hairless terrier' then 1167
    when 'american pit bull terrier' then 801
    when 'american staffordshire terrier' then 1082
    when 'anatolian shepherd' then 7
    when 'australian cattle dog' then 8
    when 'australian kelpie' then 9
    when 'australian shepherd' then 10
    when 'australian terrier' then 802
    when 'basenji' then 12
    when 'basset hound' then 13
    when 'beagle' then 14
    when 'bearded collie' then 15
    when 'beauceron' then 803
    when 'bedlington terrier' then 189
    when 'belgian laekenois' then 1168
    when 'belgian malinois' then 191
    when 'belgian shepherd' then 16
    when 'belgian tervuren' then 192
    when 'bernese mountain dog' then 17
    when 'bichon frise' then 18
    when 'black mouth cur' then 804
    when 'black and tan coonhound' then 19
    when 'bloodhound' then 20
    when 'blue lacy/texas lacy' then 1368
    when 'bluetick coonhound' then 193
    when 'bolognese' then 1165
    when 'border collie' then 21
    when 'border terrier' then 194
    when 'borzoi' then 22
    when 'boston terrier' then 23
    when 'bouvier des flandres' then 24
    when 'boxer' then 25
    when 'boykin spaniel' then 601
    when 'briard' then 26
    when 'brittany' then 27
    when 'brussels griffon' then 195
    when 'bull terrier' then 28
    when 'bullmastiff' then 30
    when 'cairn terrier' then 31
    when 'canaan dog' then 381
    when 'cane corso' then 461
    when 'carolina dog' then 805
    when 'catahoula leopard dog' then 33
    when 'cavalier king charles spaniel' then 34
    when 'chesapeake bay retriever' then 35
    when 'chihuahua' then 36
    when 'chinese crested' then 37
    when 'chow chow' then 38
    when 'clumber spaniel' then 196
    when 'cockapoo' then 39
    when 'cocker spaniel' then 40
    when 'english cocker spaniel' then 40
    when 'collie' then 41
    when 'coonhound' then 42
    when 'corgi' then 230
    when 'coton de tulear' then 521
    when 'curly-coated retriever' then 1169
    when 'dachshund' then 44
    when 'dalmatian' then 45
    when 'dandie dinmont terrier' then 199
    when 'doberman pinscher' then 46
    when 'dogo argentino' then 621
    when 'dogue de bordeaux' then 242
    when 'dutch shepherd' then 47
    when 'english (redtick) coonhound' then 1186
    when 'english bulldog' then 29
    when 'english setter' then 49
    when 'english shepherd' then 641
    when 'english springer spaniel' then 51
    when 'english toy spaniel' then 52
    when 'entlebucher' then 808
    when 'feist' then 310
    when 'field spaniel' then 201
    when 'fila brasileiro' then 810
    when 'finnish lapphund' then 811
    when 'finnish spitz' then 54
    when 'flat-coated retriever' then 202
    when 'fox terrier (smooth)' then 812
    when 'fox terrier (toy)' then 813
    when 'fox terrier (wirehaired)' then 55
    when 'foxhound' then 56
    when 'french bulldog' then 203
    when 'german pinscher' then 814
    when 'german shepherd dog' then 57
    when 'german shorthaired pointer' then 58
    when 'german wirehaired pointer' then 204
    when 'glen of imaal terrier' then 815
    when 'golden retriever' then 60
    when 'goldendoodle' then 1369
    when 'gordon setter' then 61
    when 'great dane' then 62
    when 'great pyrenees' then 63
    when 'greater swiss mountain dog' then 205
    when 'greyhound' then 64
    when 'halden hound (haldenstrover)' then 661
    when 'harrier' then 206
    when 'havanese' then 501
    when 'hovawart' then 816
    when 'husky' then 817
    when 'ibizan hound' then 281
    when 'irish setter' then 67
    when 'irish terrier' then 207
    when 'irish water spaniel' then 208
    when 'irish wolfhound' then 68
    when 'italian greyhound' then 69
    when 'italian spinone' then 818
    when 'jack russell terrier' then 70
    when 'japanese chin' then 71
    when 'jindo' then 72
    when 'kai dog' then 819
    when 'karelian bear dog' then 820
    when 'keeshond' then 73
    when 'kerry blue terrier' then 209
    when 'kishu' then 821
    when 'komondor' then 210
    when 'kuvasz' then 74
    when 'kyi leo' then 822
    when 'labradoodle' then 1170
    when 'labrador retriever' then 823
    when 'lakeland terrier' then 211
    when 'lancashire heeler' then 826
    when 'leonberger' then 827
    when 'lhasa apso' then 76
    when 'löwchen' then 1187
    when 'maltese' then 77
    when 'manchester terrier' then 78
    when 'maremma sheepdog' then 828
    when 'mastiff' then 200
    when 'miniature pinscher' then 80
    when 'mountain cur' then 829
    when 'munsterlander' then 830
    when 'neapolitan mastiff' then 83
    when 'newfoundland' then 84
    when 'norfolk terrier' then 214
    when 'norwegian buhund' then 831
    when 'norwegian elkhound' then 85
    when 'norwich terrier' then 215
    when 'nova scotia duck-tolling retriever' then 832
    when 'old english sheepdog' then 302
    when 'otterhound' then 87
    when 'papillon' then 88
    when 'patterdale terrier (fell terrier)' then 833
    when 'pekingese' then 89
    when 'petit basset griffon vendeen' then 216
    when 'pharaoh hound' then 90
    when 'plott hound' then 581
    when 'podengo portugueso' then 834
    when 'portuguese podengo' then 834
    when 'portuguese podengo pequeno' then 834
    when 'pointer' then 92
    when 'polish lowland sheepdog' then 1166
    when 'pomeranian' then 93
    when 'poodle (miniature)' then 213
    when 'miniature poodle' then 213
    when 'poodle (standard)' then 94
    when 'poodle (toy or tea cup)' then 226
    when 'toy poodle' then 226
    when 'portuguese water dog' then 95
    when 'presa canario' then 1188
    when 'pug' then 96
    when 'puli' then 1189
    when 'pumi' then 835
    when 'rat terrier' then 218
    when 'redbone coonhound' then 664
    when 'rhodesian ridgeback' then 98
    when 'rottweiler' then 99
    when 'saluki' then 101
    when 'samoyed' then 102
    when 'schiller hound' then 662
    when 'schipperke' then 103
    when 'schnauzer (giant)' then 836
    when 'schnauzer (miniature)' then 837
    when 'schnauzer (standard)' then 104
    when 'scottie, scottish terrier' then 105
    when 'scottish deerhound' then 219
    when 'sealyham terrier' then 220
    when 'shar pei' then 107
    when 'sheltie, shetland sheepdog' then 108
    when 'shiba inu' then 110
    when 'shih tzu' then 111
    when 'silky terrier' then 113
    when 'skye terrier' then 221
    when 'sloughi' then 841
    when 'st. bernard' then 100
    when 'sussex spaniel' then 222
    when 'swedish vallhund' then 846
    when 'thai ridgeback' then 561
    when 'tibetan mastiff' then 224
    when 'tibetan spaniel' then 225
    when 'tibetan terrier' then 118
    when 'tosa inu' then 848
    when 'treeing walker coonhound' then 119
    when 'vizsla' then 120
    when 'weimaraner' then 121
    when 'welsh springer spaniel' then 849
    when 'welsh terrier' then 227
    when 'westie, west highland white terrier' then 123
    when 'wheaten terrier' then 124
    when 'whippet' then 125
    when 'wirehaired pointing griffon' then 127
    when 'xoloitzcuintle/mexican hairless' then 212
    when 'yorkie, yorkshire terrier' then 244
    when 'yorkie' then 244
    when 'yorkshire terrier' then 244
    when 'abyssinian' then 967
    when 'american bobtail' then 1119
    when 'american curl' then 1120
    when 'american shorthair' then 968
    when 'american wirehair' then 1122
    when 'balinese' then 969
    when 'bengal' then 970
    when 'birman' then 971
    when 'bombay' then 972
    when 'british shorthair' then 973
    when 'burmese' then 974
    when 'chartreux' then 1123
    when 'colorpoint shorthair' then 1124
    when 'cornish rex' then 1125
    when 'cymric' then 1139
    when 'devon rex' then 1126
    when 'domestic longhair' then 1127
    when 'domestic mediumhair' then 1128
    when 'domestic shorthair' then 1129
    when 'egyptian mau' then 1130
    when 'european burmese' then 1131
    when 'exotic' then 1132
    when 'havana brown' then 1133
    when 'himalayan' then 976
    when 'japanese bobtail' then 1134
    when 'javanese' then 1135
    when 'korat' then 1136
    when 'laperm' then 1137
    when 'maine coon' then 977
    when 'manx' then 1138
    when 'munchkin' then 1191
    when 'norwegian forest cat' then 979
    when 'ocicat' then 980
    when 'oriental' then 1140
    when 'persian' then 981
    when 'polydactyl/hemingway' then 1192
    when 'ragamuffin' then 1141
    when 'ragdoll' then 982
    when 'russian blue' then 983
    when 'scottish fold' then 1142
    when 'selkirk rex' then 1143
    when 'siamese' then 984
    when 'siberian' then 1151
    when 'singapura' then 1145
    when 'snowshoe' then 985
    when 'somali' then 1146
    when 'sphynx' then 1147
    when 'tonkinese' then 1148
    when 'turkish angora' then 1149
    when 'turkish van' then 986
    when 'american' then 1199
    when 'american fuzzy lop' then 1201
    when 'american sable' then 1202
    when 'angora, english' then 1214
    when 'angora, french' then 1219
    when 'angora, giant' then 1221
    when 'angora, satin' then 1240
    when 'belgian hare' then 1203
    when 'beveren' then 1204
    when 'blanc de hotot' then 1205
    when 'britannia petite' then 1206
    when 'californian' then 1207
    when 'champagne d\'argent' then 1208
    when 'checkered giant' then 1209
    when 'chinchilla, american' then 1200
    when 'chinchilla, giant' then 1222
    when 'chinchilla, standard' then 1244
    when 'cinnamon' then 1210
    when 'creme d\'argent' then 1211
    when 'dutch' then 1212
    when 'dwarf' then 1365
    when 'dwarf hotot' then 1213
    when 'english spot' then 1216
    when 'flemish giant' then 1217
    when 'florida white' then 1218
    when 'harlequin' then 1223
    when 'havana' then 1224
    when 'himalayan' then 1225
    when 'jersey wooly' then 1227
    when 'lilac' then 1228
    when 'lionhead' then 1229
    when 'lop, english' then 1215
    when 'lop, french' then 1220
    when 'lop, holland' then 1226
    when 'lop-eared' then 1366
    when 'mini lop' then 1230
    when 'mini rex' then 1231
    when 'mini satin' then 1232
    when 'netherland dwarf' then 1233
    when 'new zealand' then 1234
    when 'palomino' then 1235
    when 'polish' then 1236
    when 'rex' then 1237
    when 'rhinelander' then 1238
    when 'satin' then 1239
    when 'silver' then 1241
    when 'silver fox' then 1242
    when 'silver marten' then 1243
    when 'tan' then 1245
    when 'thrianta' then 1246
    when 'other/uncategorized' then 1364
    when 'african grey' then 1259
    when 'amazon' then 1260
    when 'brotogeris' then 1261
    when 'budgie' then 1262
    when 'button quail' then 1263
    when 'caique' then 1264
    when 'canary' then 1265
    when 'chicken' then 1266
    when 'cockatiel' then 1267
    when 'cockatoo' then 1268
    when 'conure' then 1269
    when 'dove' then 1270
    when 'duck' then 1271
    when 'eclectus' then 1272
    when 'emu' then 1273
    when 'finch' then 1274
    when 'goose' then 1275
    when 'guinea fowl' then 1276
    when 'kakariki' then 1277
    when 'lorikeet' then 1278
    when 'lovebird' then 1279
    when 'macaw' then 1280
    when 'mynah' then 1281
    when 'ostrich' then 1282
    when 'parakeet - other' then 1284
    when 'parakeet - quaker' then 1283
    when 'parrotlet' then 1286
    when 'parrot - other' then 1285
    when 'peacock' then 1287
    when 'pheasant' then 1288
    when 'pigeon' then 1289
    when 'pionus' then 1290
    when 'poicephalus (including senegal and meyer\'s)' then 1291
    when 'quail' then 1292
    when 'rhea' then 1293
    when 'ringneck' then 1294
    when 'rosella' then 1295
    when 'softbill - other' then 1296
    when 'swan' then 1297
    when 'toucan' then 1298
    when 'turkey' then 1299
    when 'other/uncategorized' then 1367
    when 'chinchilla' then 1247
    when 'degu' then 1248
    when 'ferret' then 1249
    when 'gerbil' then 1250
    when 'guinea pig' then 1251
    when 'hamster' then 1252
    when 'hedgehog' then 1253
    when 'mouse' then 1254
    when 'prairie dog' then 1255
    when 'rat' then 1256
    when 'skunk' then 1257
    when 'sugar glider' then 1258
    when 'andalusian' then 1300
    when 'appaloosa' then 1301
    when 'appendix' then 1302
    when 'arabian' then 1303
    when 'belgian' then 1304
    when 'clydesdale' then 1305
    when 'curly horse' then 1306
    when 'donkey/mule/burro/hinny' then 1307
    when 'draft' then 1308
    when 'friesian' then 1309
    when 'gaited' then 1310
    when 'grade' then 1311
    when 'gypsy vanner' then 1312
    when 'haflinger' then 1313
    when 'lipizzaner' then 1314
    when 'miniature' then 1315
    when 'missouri foxtrotter' then 1316
    when 'morgan' then 1317
    when 'mustang' then 1318
    when 'norwegian fjord' then 1319
    when 'paint/pinto' then 1321
    when 'palomino' then 1322
    when 'paso fino' then 1323
    when 'percheron' then 1324
    when 'peruvian paso' then 1325
    when 'pony - chincoteague' then 1370
    when 'pony - connemara' then 1326
    when 'pony - dales' then 1327
    when 'pony - dartmoor' then 1328
    when 'pony - fell' then 1329
    when 'pony - new forest' then 1330
    when 'pony - of america' then 1331
    when 'pony - other' then 1332
    when 'pony - shetland' then 1333
    when 'pony - welsh' then 1334
    when 'quarterhorse' then 1335
    when 'rocky mountain' then 1336
    when 'saddlebred' then 1337
    when 'standardbred' then 1338
    when 'tennessee walking horse' then 1339
    when 'thoroughbred' then 1340
    when 'trakhener' then 1341
    when 'warmblood' then 1342
    when 'other/uncategorized' then 1320
    when 'fish' then 1353
    when 'frog' then 1349
    when 'gecko' then 1355
    when 'iguana' then 1345
    when 'lizard' then 1344
    when 'scorpion' then 1351
    when 'sea life (non-fish)' then 1354
    when 'snake' then 1343
    when 'tarantula' then 1352
    when 'toad' then 1350
    when 'tortoise' then 1346
    when 'turtle - other' then 1348
    when 'turtle - water' then 1347
    when 'alpaca' then 1356
    when 'cow or bull' then 1357
    when 'goat' then 1358
    when 'llama' then 1359
    when 'other' then 1363
    when 'pig (farm)' then 1361
    when 'pig (potbellied)' then 1360
    when 'sheep' then 1362
    else raise "Unknown breed: #{breed}"
    end

  # document.querySelectorAll('[name=family_id] option').forEach(function (o) { if (o.value.startsWith('real')) { var parts = o.value.split('|'); console.log('    when \'' + parts[1].toLowerCase() + '\' then \'' + parts[1] + '\''); }})
  family_name = 
    case breed.downcase
    when 'affenpinscher' then 'Affenpinscher'
    when 'afghan hound' then 'Afghan Hound'
    when 'airedale terrier' then 'Airedale Terrier'
    when 'akbash' then 'Akbash'
    when 'akita' then 'Akita'
    when 'alaskan malamute' then 'Alaskan Malamute'
    when 'american bulldog' then 'American Bulldog'
    when 'american eskimo dog' then 'American Eskimo Dog'
    when 'american hairless terrier' then 'American Hairless Terrier'
    when 'american pit bull terrier' then 'American Pit Bull Terrier'
    when 'american staffordshire terrier' then 'American Staffordshire Terrier'
    when 'anatolian shepherd' then 'Anatolian Shepherd'
    when 'australian cattle dog' then 'Australian Cattle Dog'
    when 'australian kelpie' then 'Australian Kelpie'
    when 'australian shepherd' then 'Australian Shepherd'
    when 'australian terrier' then 'Australian Terrier'
    when 'basenji' then 'Basenji'
    when 'basset hound' then 'Basset Hound'
    when 'beagle' then 'Beagle'
    when 'bearded collie' then 'Bearded Collie'
    when 'beauceron' then 'Beauceron'
    when 'bedlington terrier' then 'Bedlington Terrier'
    when 'belgian laekenois' then 'Belgian Laekenois'
    when 'belgian malinois' then 'Belgian Malinois'
    when 'belgian shepherd' then 'Belgian Shepherd'
    when 'belgian tervuren' then 'Belgian Tervuren'
    when 'bernese mountain dog' then 'Bernese Mountain Dog'
    when 'bichon frise' then 'Bichon Frise'
    when 'black mouth cur' then 'Black Mouth Cur'
    when 'black and tan coonhound' then 'Black and Tan Coonhound'
    when 'bloodhound' then 'Bloodhound'
    when 'blue lacy/texas lacy' then 'Blue Lacy/Texas Lacy'
    when 'bluetick coonhound' then 'Bluetick Coonhound'
    when 'bolognese' then 'Bolognese'
    when 'border collie' then 'Border Collie'
    when 'border terrier' then 'Border Terrier'
    when 'borzoi' then 'Borzoi'
    when 'boston terrier' then 'Boston Terrier'
    when 'bouvier des flandres' then 'Bouvier des Flandres'
    when 'boxer' then 'Boxer'
    when 'boykin spaniel' then 'Boykin Spaniel'
    when 'briard' then 'Briard'
    when 'brittany' then 'Brittany'
    when 'brussels griffon' then 'Brussels Griffon'
    when 'bull terrier' then 'Bull Terrier'
    when 'bullmastiff' then 'Bullmastiff'
    when 'cairn terrier' then 'Cairn Terrier'
    when 'canaan dog' then 'Canaan Dog'
    when 'cane corso' then 'Cane Corso'
    when 'carolina dog' then 'Carolina Dog'
    when 'catahoula leopard dog' then 'Catahoula Leopard Dog'
    when 'cavalier king charles spaniel' then 'Cavalier King Charles Spaniel'
    when 'chesapeake bay retriever' then 'Chesapeake Bay Retriever'
    when 'chihuahua' then 'Chihuahua'
    when 'chinese crested' then 'Chinese Crested'
    when 'chow chow' then 'Chow Chow'
    when 'clumber spaniel' then 'Clumber Spaniel'
    when 'cockapoo' then 'Cockapoo'
    when 'cocker spaniel' then 'Cocker Spaniel'
    when 'english cocker spaniel' then 'Cocker Spaniel'
    when 'collie' then 'Collie'
    when 'coonhound' then 'Coonhound'
    when 'corgi' then 'Corgi'
    when 'coton de tulear' then 'Coton de Tulear'
    when 'curly-coated retriever' then 'Curly-Coated Retriever'
    when 'dachshund' then 'Dachshund'
    when 'dalmatian' then 'Dalmatian'
    when 'dandie dinmont terrier' then 'Dandie Dinmont Terrier'
    when 'doberman pinscher' then 'Doberman Pinscher'
    when 'dogo argentino' then 'Dogo Argentino'
    when 'dogue de bordeaux' then 'Dogue de Bordeaux'
    when 'dutch shepherd' then 'Dutch Shepherd'
    when 'english (redtick) coonhound' then 'English (Redtick) Coonhound'
    when 'english bulldog' then 'English Bulldog'
    when 'english setter' then 'English Setter'
    when 'english shepherd' then 'English Shepherd'
    when 'english springer spaniel' then 'English Springer Spaniel'
    when 'english toy spaniel' then 'English Toy Spaniel'
    when 'entlebucher' then 'Entlebucher'
    when 'feist' then 'Feist'
    when 'field spaniel' then 'Field Spaniel'
    when 'fila brasileiro' then 'Fila Brasileiro'
    when 'finnish lapphund' then 'Finnish Lapphund'
    when 'finnish spitz' then 'Finnish Spitz'
    when 'flat-coated retriever' then 'Flat-Coated Retriever'
    when 'fox terrier (smooth)' then 'Fox Terrier (Smooth)'
    when 'fox terrier (toy)' then 'Fox Terrier (Toy)'
    when 'fox terrier (wirehaired)' then 'Fox Terrier (Wirehaired)'
    when 'foxhound' then 'Foxhound'
    when 'french bulldog' then 'French Bulldog'
    when 'german pinscher' then 'German Pinscher'
    when 'german shepherd dog' then 'German Shepherd Dog'
    when 'german shorthaired pointer' then 'German Shorthaired Pointer'
    when 'german wirehaired pointer' then 'German Wirehaired Pointer'
    when 'glen of imaal terrier' then 'Glen of Imaal Terrier'
    when 'golden retriever' then 'Golden Retriever'
    when 'goldendoodle' then 'Goldendoodle'
    when 'gordon setter' then 'Gordon Setter'
    when 'great dane' then 'Great Dane'
    when 'great pyrenees' then 'Great Pyrenees'
    when 'greater swiss mountain dog' then 'Greater Swiss Mountain Dog'
    when 'greyhound' then 'Greyhound'
    when 'halden hound (haldenstrover)' then 'Halden Hound (Haldenstrover)'
    when 'harrier' then 'Harrier'
    when 'havanese' then 'Havanese'
    when 'hovawart' then 'Hovawart'
    when 'husky' then 'Husky'
    when 'ibizan hound' then 'Ibizan Hound'
    when 'irish setter' then 'Irish Setter'
    when 'irish terrier' then 'Irish Terrier'
    when 'irish water spaniel' then 'Irish Water Spaniel'
    when 'irish wolfhound' then 'Irish Wolfhound'
    when 'italian greyhound' then 'Italian Greyhound'
    when 'italian spinone' then 'Italian Spinone'
    when 'jack russell terrier' then 'Jack Russell Terrier'
    when 'japanese chin' then 'Japanese Chin'
    when 'jindo' then 'Jindo'
    when 'kai dog' then 'Kai Dog'
    when 'karelian bear dog' then 'Karelian Bear Dog'
    when 'keeshond' then 'Keeshond'
    when 'kerry blue terrier' then 'Kerry Blue Terrier'
    when 'kishu' then 'Kishu'
    when 'komondor' then 'Komondor'
    when 'kuvasz' then 'Kuvasz'
    when 'kyi leo' then 'Kyi Leo'
    when 'labradoodle' then 'Labradoodle'
    when 'labrador retriever' then 'Labrador Retriever'
    when 'lakeland terrier' then 'Lakeland Terrier'
    when 'lancashire heeler' then 'Lancashire Heeler'
    when 'leonberger' then 'Leonberger'
    when 'lhasa apso' then 'Lhasa Apso'
    when 'löwchen' then 'Löwchen'
    when 'maltese' then 'Maltese'
    when 'manchester terrier' then 'Manchester Terrier'
    when 'maremma sheepdog' then 'Maremma Sheepdog'
    when 'mastiff' then 'Mastiff'
    when 'miniature pinscher' then 'Miniature Pinscher'
    when 'mountain cur' then 'Mountain Cur'
    when 'munsterlander' then 'Munsterlander'
    when 'neapolitan mastiff' then 'Neapolitan Mastiff'
    when 'newfoundland' then 'Newfoundland'
    when 'norfolk terrier' then 'Norfolk Terrier'
    when 'norwegian buhund' then 'Norwegian Buhund'
    when 'norwegian elkhound' then 'Norwegian Elkhound'
    when 'norwich terrier' then 'Norwich Terrier'
    when 'nova scotia duck-tolling retriever' then 'Nova Scotia Duck-Tolling Retriever'
    when 'old english sheepdog' then 'Old English Sheepdog'
    when 'otterhound' then 'Otterhound'
    when 'papillon' then 'Papillon'
    when 'patterdale terrier (fell terrier)' then 'Patterdale Terrier (Fell Terrier)'
    when 'pekingese' then 'Pekingese'
    when 'petit basset griffon vendeen' then 'Petit Basset Griffon Vendeen'
    when 'pharaoh hound' then 'Pharaoh Hound'
    when 'plott hound' then 'Plott Hound'
    when 'podengo portugueso' then 'Podengo Portugueso'
    when 'portuguese podengo' then 'Podengo Portugueso'
    when 'portuguese podengo pequeno' then 'Podengo Portugueso'
    when 'pointer' then 'Pointer'
    when 'polish lowland sheepdog' then 'Polish Lowland Sheepdog'
    when 'pomeranian' then 'Pomeranian'
    when 'poodle (miniature)' then 'Poodle (Miniature)'
    when 'miniature poodle' then 'Poodle (Miniature)'
    when 'poodle (standard)' then 'Poodle (Standard)'
    when 'poodle (toy or tea cup)' then 'Poodle (Toy or Tea Cup)'
    when 'toy poodle' then 'Poodle (Toy or Tea Cup)'
    when 'portuguese water dog' then 'Portuguese Water Dog'
    when 'presa canario' then 'Presa Canario'
    when 'pug' then 'Pug'
    when 'puli' then 'Puli'
    when 'pumi' then 'Pumi'
    when 'rat terrier' then 'Rat Terrier'
    when 'redbone coonhound' then 'Redbone Coonhound'
    when 'rhodesian ridgeback' then 'Rhodesian Ridgeback'
    when 'rottweiler' then 'Rottweiler'
    when 'saluki' then 'Saluki'
    when 'samoyed' then 'Samoyed'
    when 'schiller hound' then 'Schiller Hound'
    when 'schipperke' then 'Schipperke'
    when 'schnauzer (giant)' then 'Schnauzer (Giant)'
    when 'schnauzer (miniature)' then 'Schnauzer (Miniature)'
    when 'schnauzer (standard)' then 'Schnauzer (Standard)'
    when 'scottie, scottish terrier' then 'Scottie, Scottish Terrier'
    when 'scottish deerhound' then 'Scottish Deerhound'
    when 'sealyham terrier' then 'Sealyham Terrier'
    when 'shar pei' then 'Shar Pei'
    when 'sheltie, shetland sheepdog' then 'Sheltie, Shetland Sheepdog'
    when 'shiba inu' then 'Shiba Inu'
    when 'shih tzu' then 'Shih Tzu'
    when 'silky terrier' then 'Silky Terrier'
    when 'skye terrier' then 'Skye Terrier'
    when 'sloughi' then 'Sloughi'
    when 'st. bernard' then 'St. Bernard'
    when 'sussex spaniel' then 'Sussex Spaniel'
    when 'swedish vallhund' then 'Swedish Vallhund'
    when 'thai ridgeback' then 'Thai Ridgeback'
    when 'tibetan mastiff' then 'Tibetan Mastiff'
    when 'tibetan spaniel' then 'Tibetan Spaniel'
    when 'tibetan terrier' then 'Tibetan Terrier'
    when 'tosa inu' then 'Tosa Inu'
    when 'treeing walker coonhound' then 'Treeing Walker Coonhound'
    when 'vizsla' then 'Vizsla'
    when 'weimaraner' then 'Weimaraner'
    when 'welsh springer spaniel' then 'Welsh Springer Spaniel'
    when 'welsh terrier' then 'Welsh Terrier'
    when 'westie, west highland white terrier' then 'Westie, West Highland White Terrier'
    when 'wheaten terrier' then 'Wheaten Terrier'
    when 'whippet' then 'Whippet'
    when 'wirehaired pointing griffon' then 'Wirehaired Pointing Griffon'
    when 'xoloitzcuintle/mexican hairless' then 'Xoloitzcuintle/Mexican Hairless'
    when 'yorkie, yorkshire terrier' then 'Yorkie, Yorkshire Terrier'
    when 'yorkie' then 'Yorkie, Yorkshire Terrier'
    when 'yorkshire terrier' then 'Yorkie, Yorkshire Terrier'
    when 'abyssinian' then 'Abyssinian'
    when 'american bobtail' then 'American Bobtail'
    when 'american curl' then 'American Curl'
    when 'american shorthair' then 'American Shorthair'
    when 'american wirehair' then 'American Wirehair'
    when 'balinese' then 'Balinese'
    when 'bengal' then 'Bengal'
    when 'birman' then 'Birman'
    when 'bombay' then 'Bombay'
    when 'british shorthair' then 'British Shorthair'
    when 'burmese' then 'Burmese'
    when 'chartreux' then 'Chartreux'
    when 'colorpoint shorthair' then 'Colorpoint Shorthair'
    when 'cornish rex' then 'Cornish Rex'
    when 'cymric' then 'Cymric'
    when 'devon rex' then 'Devon Rex'
    when 'domestic longhair' then 'Domestic Longhair'
    when 'domestic mediumhair' then 'Domestic Mediumhair'
    when 'domestic shorthair' then 'Domestic Shorthair'
    when 'egyptian mau' then 'Egyptian Mau'
    when 'european burmese' then 'European Burmese'
    when 'exotic' then 'Exotic'
    when 'havana brown' then 'Havana Brown'
    when 'himalayan' then 'Himalayan'
    when 'japanese bobtail' then 'Japanese Bobtail'
    when 'javanese' then 'Javanese'
    when 'korat' then 'Korat'
    when 'laperm' then 'LaPerm'
    when 'maine coon' then 'Maine Coon'
    when 'manx' then 'Manx'
    when 'munchkin' then 'Munchkin'
    when 'norwegian forest cat' then 'Norwegian Forest Cat'
    when 'ocicat' then 'Ocicat'
    when 'oriental' then 'Oriental'
    when 'persian' then 'Persian'
    when 'polydactyl/hemingway' then 'Polydactyl/Hemingway'
    when 'ragamuffin' then 'RagaMuffin'
    when 'ragdoll' then 'Ragdoll'
    when 'russian blue' then 'Russian Blue'
    when 'scottish fold' then 'Scottish Fold'
    when 'selkirk rex' then 'Selkirk Rex'
    when 'siamese' then 'Siamese'
    when 'siberian' then 'Siberian'
    when 'singapura' then 'Singapura'
    when 'snowshoe' then 'Snowshoe'
    when 'somali' then 'Somali'
    when 'sphynx' then 'Sphynx'
    when 'tonkinese' then 'Tonkinese'
    when 'turkish angora' then 'Turkish Angora'
    when 'turkish van' then 'Turkish Van'
    when 'african grey' then 'African Grey'
    when 'amazon' then 'Amazon'
    when 'brotogeris' then 'Brotogeris'
    when 'budgie' then 'Budgie'
    when 'button quail' then 'Button Quail'
    when 'caique' then 'Caique'
    when 'canary' then 'Canary'
    when 'chicken' then 'Chicken'
    when 'cockatiel' then 'Cockatiel'
    when 'cockatoo' then 'Cockatoo'
    when 'conure' then 'Conure'
    when 'dove' then 'Dove'
    when 'duck' then 'Duck'
    when 'eclectus' then 'Eclectus'
    when 'emu' then 'Emu'
    when 'finch' then 'Finch'
    when 'goose' then 'Goose'
    when 'guinea fowl' then 'Guinea Fowl'
    when 'kakariki' then 'Kakariki'
    when 'lorikeet' then 'Lorikeet'
    when 'lovebird' then 'Lovebird'
    when 'macaw' then 'Macaw'
    when 'mynah' then 'Mynah'
    when 'ostrich' then 'Ostrich'
    when 'parakeet - other' then 'Parakeet - Other'
    when 'parakeet - quaker' then 'Parakeet - Quaker'
    when 'parrotlet' then 'Parrotlet'
    when 'parrot - other' then 'Parrot - Other'
    when 'peacock' then 'Peacock'
    when 'pheasant' then 'Pheasant'
    when 'pigeon' then 'Pigeon'
    when 'pionus' then 'Pionus'
    when 'poicephalus (including senegal and meyer\'s)' then 'Poicephalus (including Senegal and Meyer\'s)'
    when 'quail' then 'Quail'
    when 'rhea' then 'Rhea'
    when 'ringneck' then 'Ringneck'
    when 'rosella' then 'Rosella'
    when 'softbill - other' then 'Softbill - Other'
    when 'swan' then 'Swan'
    when 'toucan' then 'Toucan'
    when 'turkey' then 'Turkey'
    when 'other/uncategorized' then 'Other/Uncategorized'
    when 'chinchilla' then 'Chinchilla'
    when 'degu' then 'Degu'
    when 'ferret' then 'Ferret'
    when 'gerbil' then 'Gerbil'
    when 'guinea pig' then 'Guinea Pig'
    when 'hamster' then 'Hamster'
    when 'hedgehog' then 'Hedgehog'
    when 'mouse' then 'Mouse'
    when 'prairie dog' then 'Prairie Dog'
    when 'rat' then 'Rat'
    when 'skunk' then 'Skunk'
    when 'sugar glider' then 'Sugar Glider'
    when 'andalusian' then 'Andalusian'
    when 'appaloosa' then 'Appaloosa'
    when 'appendix' then 'Appendix'
    when 'arabian' then 'Arabian'
    when 'belgian' then 'Belgian'
    when 'clydesdale' then 'Clydesdale'
    when 'curly horse' then 'Curly Horse'
    when 'donkey/mule/burro/hinny' then 'Donkey/Mule/Burro/Hinny'
    when 'draft' then 'Draft'
    when 'friesian' then 'Friesian'
    when 'gaited' then 'Gaited'
    when 'grade' then 'Grade'
    when 'gypsy vanner' then 'Gypsy Vanner'
    when 'haflinger' then 'Haflinger'
    when 'lipizzaner' then 'Lipizzaner'
    when 'miniature' then 'Miniature'
    when 'missouri foxtrotter' then 'Missouri Foxtrotter'
    when 'morgan' then 'Morgan'
    when 'mustang' then 'Mustang'
    when 'norwegian fjord' then 'Norwegian Fjord'
    when 'paint/pinto' then 'Paint/Pinto'
    when 'palomino' then 'Palomino'
    when 'paso fino' then 'Paso Fino'
    when 'percheron' then 'Percheron'
    when 'peruvian paso' then 'Peruvian Paso'
    when 'pony - chincoteague' then 'Pony - Chincoteague'
    when 'pony - connemara' then 'Pony - Connemara'
    when 'pony - dales' then 'Pony - Dales'
    when 'pony - dartmoor' then 'Pony - Dartmoor'
    when 'pony - fell' then 'Pony - Fell'
    when 'pony - new forest' then 'Pony - New Forest'
    when 'pony - of america' then 'Pony - of America'
    when 'pony - other' then 'Pony - Other'
    when 'pony - shetland' then 'Pony - Shetland'
    when 'pony - welsh' then 'Pony - Welsh'
    when 'quarterhorse' then 'Quarterhorse'
    when 'rocky mountain' then 'Rocky Mountain'
    when 'saddlebred' then 'Saddlebred'
    when 'standardbred' then 'Standardbred'
    when 'tennessee walking horse' then 'Tennessee Walking Horse'
    when 'thoroughbred' then 'Thoroughbred'
    when 'trakhener' then 'Trakhener'
    when 'warmblood' then 'Warmblood'
    when 'other/uncategorized' then 'Other/Uncategorized'
    when 'fish' then 'Fish'
    when 'frog' then 'Frog'
    when 'gecko' then 'Gecko'
    when 'iguana' then 'Iguana'
    when 'lizard' then 'Lizard'
    when 'scorpion' then 'Scorpion'
    when 'sea life (non-fish)' then 'Sea Life (non-fish)'
    when 'snake' then 'Snake'
    when 'tarantula' then 'Tarantula'
    when 'toad' then 'Toad'
    when 'tortoise' then 'Tortoise'
    when 'turtle - other' then 'Turtle - Other'
    when 'turtle - water' then 'Turtle - Water'
    when 'alpaca' then 'Alpaca'
    when 'cow or bull' then 'Cow or Bull'
    when 'goat' then 'Goat'
    when 'llama' then 'Llama'
    when 'other' then 'Other'
    when 'pig (farm)' then 'Pig (Farm)'
    when 'pig (potbellied)' then 'Pig (Potbellied)'
    when 'sheep' then 'Sheep'
    else raise "Unknown breed: #{breed}"
    end

  gender = target_gender.downcase[0, 1]

  doc = Nokogiri::HTML(open("http://www.adoptapet.com/#{target_species.downcase}-adoption/search/#{target_distance}/miles/#{target_zip}?family_name=#{family_name}&age=#{target_age.downcase}&sex=#{gender}&family_id=#{family_id}"))

  # A page with matches will have 2 headers: one between results and "These are not what you asked for but are close" and another for "Here are some others in your area"
  # A page without matches will only have the second header
  next if doc.css('.results_wrapper .row_heading').length < 2

  time = Time.now
  # Page source has matching and non-matching results, separated by a "row heading"
  doc.css('.results_wrapper > div').each do |elt|
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

    ads.push(Adoptable::Ad.new(name, id, time -= 24 * 60 * 60, breed, photo, url, city, notes))
  end
 end

 ads
end
