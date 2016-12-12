require File.expand_path('../../lib/ad', __FILE__)

module Adoptable
  class Job
    @@dir = File.expand_path('../../ads', __FILE__)

    def initialize(name)
      @name = name

      # Make sure jobs run every hour, but not all at the same time
      @delay = (5 * 60 * Random::rand).round   # Spread out over 5 minutes

      Dir.mkdir(@@dir) if !Dir.exists?(@@dir)

      p "#{@name}: job created (first run in #{@delay} seconds)"
    end

    def run
      SCHEDULER.every "1h", first_in: @delay do
        time = Time.now.to_i
        p "#{@name}: job running"

        ads = []
        first_time = true
        Sinatra::Application.settings.queries.each do |q|
          # Avoid rate limiting
          sleep(5) if !first_time
          first_time = false

          ads += yield(q["species"], q["breeds"], q["exclude_breeds"], q["gender"], q["age"], q["zip"], q["distance"])
        end

        ads.uniq! { |a| a.id }

        p "#{@name}: writing #{ads.length} ads in #{Time.now.to_i - time} seconds"
        File.open File.join(@@dir, "#{@name}.ads"), "w" do |f|
          f.write Marshal.dump(ads)
        end

        publish if ads.length > 0
      end
    end

    def publish
      ads = []

      # Read ad files
      Dir.glob("#{@@dir}/*.ads") do |file|
        ads += Marshal.load(File.read(file))
      end

      p "Publisher: sending #{ads.length} ad events"

      # Send events
      ads.sort_by { |ad| ad.time }.reverse.each_with_index do |ad, index|
        #p "Publisher: sending event #{index} for #{ad.ad_src}: #{ad.time}"
        send_event("ad_#{index}", ad.to_hash)
      end

      if ads.length < Sinatra::Application.settings.results then
        empty_ad = Adoptable::Ad.new(nil, nil, nil, nil, nil, nil).to_hash

        (Sinatra::Application.settings.results - ads.length).times do |index|
          index = index + ads.length
          #p "Publisher: sending empty event #{index}"
          send_event("ad_#{index}", empty_ad)
        end 
      end
    end
  end
end
