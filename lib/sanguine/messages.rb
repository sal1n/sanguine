module Sanguine

  # Collection of game-generated messages.
  #
  # @todo need to flesh this out properly
  #
  class Messages < Array
    
    def append_to_last(string)
      self[self.index(self.last)] = "#{self.last} #{string}"
    end
    
  end
  
  # At some point want to log everything and use target/origin etc but for now.
  #
  class Message
    
    attr_reader :message
    
    def initialize(message)
      @message = message
    end
    
    def to_s
      @message
    end
    
  end
  
end
