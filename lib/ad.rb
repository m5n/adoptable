module Adoptable
  class Ad
    attr_reader :ad_src, :id, :time, :img_src, :href, :city, :notes

    def initialize(ad_src, id, time, img_src, href, city, notes = [])
      @ad_src = ad_src
      @id = id
      @time = time.nil? ? nil : time.to_i
      @img_src = img_src
      @href = href
      @city = city
      @notes = notes
    end

# TODO: add mix for display

    def to_hash
      instance_variables.map { |v| [v[1..-1].to_sym, instance_variable_get(v)] }.to_h
    end
  end
end
