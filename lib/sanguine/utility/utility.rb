module Sanguine
  
  # Utility class.
  #
  class Utility
  
    # normalise a given frequency hash so that the frequencies add up to 1
    # (within the limits of floating-point arithmetic)
    def self.normalise_frequency_hash!(hash)
      sum = hash.inject(0) do |sum, object|
        sum += object[1]
      end
      sum = sum.to_f
      hash.each { |object, frequency| hash[object] = frequency/sum }
      hash
    end
    
  end
  
end