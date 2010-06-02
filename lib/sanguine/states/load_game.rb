module Sanguine

  module State
  
    class LoadGame < State
      
      def initialize
        super
        @views << View::LoadGame.new
      end

      def activate
        self[:title] = "Restore a previous game"
        self[:instructions] = "Press a key to restore the game or esc to return to the menu."
        self[:saved_games] = Array.new
        
        Dir.foreach('./saves/') do |save| 
          if save != "." && save != ".."
            self[:saved_games] << save
          end
        end
      end
      
      def command(key)
        if key.has_index? && key.index <= self[:saved_games].size
          game = self[:saved_games][key.index]
          game = Marshal.load(File.open("./saves/#{game}"))
          game.state = Map.new
          window.game = game
        elsif key == :escape
          game.change_state(Menu.new)
        end
      end
      
    end
    
  end
  
end
