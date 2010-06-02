module Sanguine
  
  # a collection of handy methods.
  #
  module HandyMethods

    def window
      GameWindow.instance
    end
    
    def keys
      self.window.keys
    end
    
    def game
      self.window.game
    end
    
    def messages
      self.game.messages
    end
    
    def player
      self.game.player
    end
    
    def factorial(n)
      if n == 0
        1
      else
        n * factorial(n - 1)
      end
    end
    
  end
  
end