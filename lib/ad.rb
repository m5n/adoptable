module Adoptable
  class Ad
    attr_reader :id, :time

    def initialize(ad_src, id, time, breed, img_src, href, city, notes = [])
      @ad_src = ad_src
      @id = id.nil? ? nil : id.to_s
      @time = time.nil? ? nil : time.to_i
      @breed = breed
      @img_src = img_src
      @href = href
      @city = city
      @notes = notes
    end

    def to_hash
      instance_variables.map { |v| [v[1..-1].to_sym, instance_variable_get(v)] }.to_h
    end

    def eql?(other)
      @id.eql?(other.id)
    end

    def hash
      @id
    end
  end
end
