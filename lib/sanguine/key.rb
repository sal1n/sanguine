module Sanguine
  
  # A key object is generated from the Gosu::button_down event, it compromises
  # of a symbol representing the actual keyboard input (including Uppercase),
  # an index representing it's position in an array (where a = 0, b = 1 etc)
  # and a possible direction for easier movement handling.
  #
  class Key
    
    attr_accessor :symbol, :index, :direction
    
    def initialize(symbol, index = nil, direction = nil)
      @symbol = symbol
      # the key index is just the numeric representation of the symbol 
      # e.g. :a = 0 this is really useful for dealing with a..z command prompts
      @index = index
      
      @direction = direction
    end
    
    def has_index?
      !@index.nil?
    end
    
    def is_direction?
      !@direction.nil?
    end
    
  end
  
end
