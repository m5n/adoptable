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

  # document.querySelectorAll('.breedlist')[0].querySelectorAll('option').forEach(function (o) { if (o.getAttribute('value')) { console.log('    when \'' + o.innerText.toLowerCase() + '\' then ' + o.getAttribute('value')); }})
  breed_id = 
    case breed.downcase
    when 'abruzzese mastiff' then 101
    when 'affenpinscher' then 696
    when 'afghan hound' then 621
    when 'aidi' then 95
    when 'ainu' then 235393
    when 'akbash' then 10
    when 'akita' then 650
    when 'alano espanol' then 11
    when 'alapaha blue blood bulldog' then 12
    when 'alaskan husky' then 13
    when 'alaskan klee kai' then 14
    when 'alaskan malamute' then 651
    when 'alopekis' then 15
    when 'alpine dachsbracke' then 16
    when 'american bandogge mastiff' then 17
    when 'american blue gascon hound' then 18
    when 'american blue heeler' then 791
    when 'american bullnese' then 19
    when 'american eskimo' then 780
    when 'american indian dog' then 20
    when 'american lo-sze pugg' then 21
    when 'american white shepherd' then 22
    when 'anatolian shepherd' then 796
    when 'appenzeller sennenhunde' then 23
    when 'argentine dogo' then 24
    when 'armant' then 93
    when 'australian cattle dog' then 733
    when 'australian kelpie' then 754
    when 'australian koolie' then 806
    when 'australian shepherd' then 734
    when 'australian shepherd, miniature' then 235394
    when 'austrian pinscher' then 817
    when 'azawakh' then 25
    when 'azores cattle dog' then 235395
    when 'banter bulldogge' then 110
    when 'barbet' then 354
    when 'basenji' then 622
    when 'basset hound' then 623
    when 'beagle' then 624
    when 'bearded collie' then 735
    when 'beauceron' then 26
    when 'belgian laekenois' then 738
    when 'belgian malinois' then 739
    when 'belgian sheepdog' then 736
    when 'belgian tervuren' then 740
    when 'bergamasco' then 27
    when 'berger des pyrenees' then 741
    when 'bernese mountain dog' then 652
    when 'bichon frise' then 716
    when 'bloodhound' then 625
    when 'boerboel' then 28
    when 'bolognese' then 3
    when 'border collie' then 676
    when 'borzoi' then 626
    when 'bouvier des ardennes' then 98
    when 'bouvier des flandres' then 742
    when 'boxer' then 653
    when 'bracco italiano' then 29
    when 'braque francais gascogne' then 590
    when 'braque francais pyrenees' then 591
    when 'briard' then 743
    when 'brittany' then 609
    when 'brittany, french' then 235396
    when 'bulldog' then 718
    when 'bulldog, american' then 85
    when 'bulldog, english' then 795
    when 'bulldog, french' then 722
    when 'bulldog, victorian' then 235397
    when 'bullmastiff' then 654
    when 'cambodian razorback dog' then 97
    when 'canaan' then 655
    when 'canadian eskimo' then 656
    when 'cane corso' then 776
    when 'cane di oropa' then 102
    when 'cane toccatore' then 103
    when 'carolina dog' then 83
    when 'carpathian shepherd dog' then 816
    when 'castro laboreiro dog' then 107
    when 'catahoula leopard dog' then 801
    when 'caucasian mountain dog' then 30
    when 'central asian outcharka shepherd' then 31
    when 'central asian shepherd dog' then 32
    when 'chihuahua, long coat' then 698
    when 'chihuahua, short coat' then 699
    when 'chinese crested' then 700
    when 'chinese foo' then 235398
    when 'chinese shar-pei' then 719
    when 'chinook' then 33
    when 'chow chow' then 720
    when 'cimarrón uruguayo' then 818
    when 'cirneco dell etna' then 235399
    when 'collie, rough' then 744
    when 'collie, smooth' then 745
    when 'coonhound' then 627
    when 'coonhound, american english' then 34
    when 'coonhound, black and tan' then 35
    when 'coonhound, bluetick' then 782
    when 'coonhound, redbone' then 36
    when 'coonhound, treeing walker' then 790
    when 'coton de tulear' then 794
    when 'croatian sheepdog' then 815
    when 'cur, black-mouth' then 82
    when 'cur, mountain' then 81
    when 'czechoslovakian wolfdog' then 37
    when 'dachshund, miniature long haired' then 628
    when 'dachshund, miniature smooth haired' then 629
    when 'dachshund, miniature wire haired' then 633
    when 'dachshund, standard long haired' then 631
    when 'dachshund, standard smooth haired' then 630
    when 'dachshund, standard wire haired' then 632
    when 'dalmatian' then 721
    when 'damchi' then 96
    when 'danish broholmer' then 235401
    when 'deerhound, scottish' then 634
    when 'doberman pinscher' then 657
    when 'dogue de bordeaux' then 778
    when 'dosa inu' then 355
    when 'drever' then 635
    when 'dunker hound' then 758
    when 'dutch sheepdog' then 353
    when 'dutch shepherd' then 235402
    when 'dutch smoushond' then 104
    when 'english mastiff' then 781
    when 'english shepherd' then 813
    when 'entlebucher mountain dog' then 38
    when 'estrela mountain dog' then 759
    when 'eurasier' then 760
    when 'feist' then 814
    when 'fila brasileiro' then 761
    when 'finnish lapphund' then 39
    when 'finnish spitz' then 636
    when 'foxhound, american' then 637
    when 'foxhound, english' then 638
    when 'german pinscher' then 792
    when 'german shepherd' then 746
    when 'german shepherd, king' then 747
    when 'german spitz' then 762
    when 'great dane' then 658
    when 'great pyrenees' then 659
    when 'greater swiss mountain dog' then 763
    when 'greenland dog' then 40
    when 'greyhound' then 639
    when 'griffon vendeen, grand basset' then 41
    when 'griffon vendeen, petit basset' then 640
    when 'griffon, brussels' then 702
    when 'griffon, wirehaired pointing' then 592
    when 'groenendael' then 737
    when 'haldenstoever' then 106
    when 'harrier' then 641
    when 'havanese' then 787
    when 'hound' then 6
    when 'hovawart' then 352
    when 'hygenhund' then 811
    when 'ibizan hound' then 642
    when 'icelandic sheepdog' then 785
    when 'irish wolfhound' then 643
    when 'italian greyhound' then 703
    when 'italiano volpino' then 235403
    when 'japanese chin' then 704
    when 'japanese spitz' then 723
    when 'kai ken' then 42
    when 'kangal' then 235404
    when 'karakachan dog' then 99
    when 'karelian bear dog' then 43
    when 'keeshond' then 724
    when 'kerry beagle' then 100
    when 'komondor' then 660
    when 'kooikerhondje' then 44
    when 'korean jindo' then 804
    when 'kromfohrlander, smooth coat' then 820
    when 'kromfohrlander, wire haired' then 821
    when 'kuvasz' then 661
    when 'lacy' then 235405
    when 'lagotto romagnolo' then 45
    when 'lancashire heeler' then 767
    when 'landseer' then 768
    when 'leonberger' then 662
    when 'lhasa apso' then 725
    when 'lowchen' then 46
    when 'maltese' then 705
    when 'maremma sheepdog' then 235406
    when 'mastiff' then 663
    when 'mcnab herding dog' then 84
    when 'mee kyun dosa' then 356
    when 'mexican hairless' then 707
    when 'miniature pinscher' then 710
    when 'mix' then 757
    when 'mixed breed, large (over 44 lbs fully grown)' then 111
    when 'mixed breed, medium (up to 44 lbs fully grown)' then 112
    when 'mixed breed, small (under 24 lbs fully grown)' then 113
    when 'mudi' then 47
    when 'munsterlander, large ' then 769
    when 'munsterlander,small' then 784
    when 'neapolitan mastiff' then 770
    when 'new guinea singing dog' then 2
    when 'newfoundland' then 664
    when 'norbottenspets' then 48
    when 'norwegian buhund' then 749
    when 'norwegian elkhound' then 644
    when 'norwegian lundehund' then 49
    when 'old english sheepdog' then 750
    when 'olde english bulldogge' then 235407
    when 'otterhound' then 645
    when 'papillon' then 708
    when 'pekingese' then 709
    when 'perdiguero gallego' then 109
    when 'perro de presa canario' then 50
    when 'peruvian inca orchid' then 51
    when 'pharaoh hound' then 646
    when 'picardy sheepdog' then 789
    when 'plott hound' then 52
    when 'podenco canario' then 94
    when 'podenco gallego' then 108
    when 'pointer' then 593
    when 'pointer, german shorthaired' then 793
    when 'pointer, german wirehaired' then 596
    when 'polish lowland sheepdog' then 357
    when 'pomeranian' then 711
    when 'poodle, miniature' then 726
    when 'miniature poodle' then 726
    when 'poodle, standard' then 727
    when 'poodle, toy' then 712
    when 'toy poodle' then 712
    when 'poong-san dog' then 351
    when 'portugese sheepdog' then 92
    when 'portuguese podengo' then 53
    when 'portuguese podengo pequeno' then 53
    when 'portuguese water dog' then 665
    when 'pudelpointer' then 597
    when 'pug' then 713
    when 'puli' then 748
    when 'pumi' then 54
    when 'pyrenean shepherd' then 55
    when 'rafeiro do alentejo' then 56
    when 'retriever' then 8
    when 'retriever, chesapeake bay' then 598
    when 'retriever, curly coated' then 599
    when 'retriever, flat-coated' then 600
    when 'retriever, golden' then 601
    when 'retriever, labrador' then 602
    when 'retriever, nova scotia duck tolling' then 603
    when 'rhodesian ridgeback' then 647
    when 'rottweiler' then 666
    when 'royal bahamian potcake' then 235408
    when 'saarloos wolfdog' then 105
    when 'saint bernard' then 671
    when 'saluki' then 648
    when 'samoyed' then 667
    when 'schipperke' then 728
    when 'schnauzer, giant' then 668
    when 'schnauzer, miniature' then 688
    when 'schnauzer, standard' then 669
    when 'schweizer laufhund (swiss hound)' then 812
    when 'setter, english' then 604
    when 'setter, gordon' then 605
    when 'setter, irish' then 606
    when 'setter, irish red and white' then 764
    when 'shepherd' then 7
    when 'shetland sheepdog' then 751
    when 'shiba inu' then 729
    when 'shih tzu' then 730
    when 'shiloh shepherd' then 235410
    when 'siberian husky' then 670
    when 'silken windhound' then 91
    when 'sloughi' then 57
    when 'south russian ovcharkas' then 235411
    when 'spaniel' then 9
    when 'spaniel, american cocker' then 607
    when 'cocker spaniel' then 607
    when 'spaniel, american water' then 608
    when 'spaniel, boykin' then 58
    when 'spaniel, cavalier king charles' then 697
    when 'cavalier king charles spaniel' then 697
    when 'spaniel, clumber' then 610
    when 'spaniel, english cocker' then 611
    when 'english cocker spaniel' then 611
    when 'spaniel, english springer' then 612
    when 'spaniel, english toy' then 701
    when 'english toy spaniel' then 701
    when 'spaniel, field' then 613
    when 'spaniel, french' then 614
    when 'spaniel, irish water' then 615
    when 'spaniel, sussex' then 616
    when 'spaniel, tibetan' then 731
    when 'spaniel, welsh springer' then 617
    when 'spanish water dog' then 805
    when 'spinone italiano' then 1
    when 'stabyhoun' then 59
    when 'swedish elkhound' then 772
    when 'swedish vallhund' then 803
    when 'tahitian bear dog' then 773
    when 'terrier' then 5
    when 'terrier, abyssinian sand' then 60
    when 'terrier, airedale' then 672
    when 'terrier, american crested sand' then 61
    when 'terrier, american hairless' then 808
    when 'terrier, american pit bull' then 87
    when 'terrier, american staffordshire' then 673
    when 'terrier, australian' then 674
    when 'terrier, bedlington' then 675
    when 'terrier, black russian' then 62
    when 'terrier, border' then 777
    when 'terrier, boston' then 717
    when 'terrier, brazilian' then 819
    when 'terrier, bull' then 677
    when 'terrier, cairn' then 678
    when 'terrier, cesky' then 63
    when 'terrier, dandie dinmont' then 679
    when 'terrier, english staffordshire' then 799
    when 'terrier, fox, smooth' then 680
    when 'terrier, fox, toy' then 80
    when 'terrier, fox, wire' then 681
    when 'terrier, glen of imaal' then 64
    when 'terrier, irish' then 682
    when 'terrier, jack russell' then 765
    when 'terrier, japanese' then 766
    when 'terrier, kerry blue' then 683
    when 'terrier, lakeland' then 684
    when 'terrier, manchester' then 685
    when 'terrier, miniature bull' then 65
    when 'terrier, norfolk' then 686
    when 'terrier, norwich' then 687
    when 'terrier, parson russell' then 66
    when 'terrier, patterdale' then 86
    when 'terrier, pit bull' then 771
    when 'terrier, rat' then 798
    when 'terrier, russell' then 809
    when 'terrier, scottish' then 689
    when 'terrier, sealyham' then 690
    when 'terrier, silky' then 714
    when 'terrier, skye' then 691
    when 'terrier, soft coated wheaten' then 692
    when 'terrier, staffordshire bull' then 693
    when 'terrier, tibetan' then 732
    when 'terrier, welsh' then 694
    when 'terrier, west highland white' then 695
    when 'terrier, yorkshire' then 715
    when 'yorkie' then 715
    when 'yorkshire terrier' then 715
    when 'thai ridgeback' then 67
    when 'tibetan mastiff' then 774
    when 'tosa' then 68
    when 'treeing tennessee brindle' then 69
    when 'vizsla, smooth haired' then 618
    when 'vizsla, wire haired' then 619
    when 'weimaraner' then 620
    when 'welsh corgi, cardigan' then 752
    when 'welsh corgi, pembroke' then 753
    when 'whippet' then 649
    when 'white swiss shepherd (berger blanc suisse)' then 810
    when 'xoloitzcuintli' then 70
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

  default_photo = "http://www.petango.com/DesktopModules/Pethealth.Petango/Pethealth.Petango.DnnModules.Common/Content/no-image-dog.jpg";
  all_ads += ads.map { |ad| Adoptable::Ad.new(name, ad["id"], time -= 24 * 60 * 60, ad["breed"], ad.include?("photo") && !ad["photo"].to_s.strip.empty? ? ad["photo"] : default_photo, ad["url"], "#{ad["distance"]} mi from #{target_zip}", notes) }
 end

 all_ads
end
