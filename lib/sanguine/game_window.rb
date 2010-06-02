require 'singleton'
 
module Sanguine
  
  # The main application class, an instance of Gosu::Window which handles the
  # drawing to screen and keyboard input.
  #
  class GameWindow < Gosu::Window

    # currently Gosu only support a single window so make singleton
    # @todo investigate ruby Singleton, I've read that it has major problems..
    include Singleton
    
    attr_accessor :font, :fonts
    
    attr_accessor :game, :keys, :tiles
    
    # constructor
    def initialize
      super(Config::ScreenWidth, Config::ScreenHeight, false, 20)
      self.caption = "Sanguine v#{Config::Version} - A Warhammer-themed Roguelike game written in Ruby / Gosu"
       
      self.load_tiles
      
      # we need a simple lookup to match symbols with indexes for menu screens
      @keys = Hash.new
      symbols = (:a..:z).to_a
      i = 0
      (0..25).to_a.each do |index|
        @keys[index] = symbols[i]
        i += 1
      end
      
      # store all game Gosu::Fonts in this hash
      @fonts = Hash.new
      # now try and load them
      # @todo test in linux/windows/osx...i suspect JSL Ancient is going to cause problems
      begin
        # try and load the default font - currently JSL Ancient 
        @fonts[:default] = Gosu::Font.new(self, Config::DefaultFont, Config::DefaultFontSize)
        @fonts[:header] = Gosu::Font.new(self, Config::DefaultFont, Config::DefaultFontSize + 8)
      rescue
        # ok that failed, try and load the system default
        @fonts[:default] = Gosu::Font.new(self, Gosu::default_font_name, Config::DefaultFontSize)
        @fonts[:header] = Gosu::Font.new(self, Gosu::default_font_name, Config::DefaultFontSize + 8)
      end
      
      # @todo remove this and replace with method
      @font = @fonts[:default]
    end

    # load game tiles
    #
    # @todo allow this to be user set?
    def load_tiles
     @tiles = Gosu::Image::load_tiles(self, "resources/sanguine_20x12.png", 12, 20, true)
    end
  
    # the Gosu button_down method, converts the id to a key object and 
    # passes it to the current game state
    def button_down(id)
      key = self.get_key(id)
      if key != nil
        @game.state.command(key)
        
        # allow repeated movement...checked by update below
        if key.direction != nil
          @last_move = key
          @last_move_time = Gosu::milliseconds
        end
      end
    end
    
    # the Gosu update method
    # @todo do diagonal movement, tweak timings
    def update
      if @last_move != nil
        if button_down?(Gosu::KbRight) || button_down?(Gosu::KbLeft) || button_down?(Gosu::KbUp) || button_down?(Gosu::KbDown)
          if Gosu::milliseconds - @last_move_time > 90
            @last_move_time = Gosu::milliseconds
            @game.state.command(@last_move)
          end
        else
          @last_move = nil
        end
      end
    end
    
    # the main Gosu draw method
    def draw
      @game.state.views.each do |view|
        view.draw
      end
    end
    
    
    # draws a box on screen
    def draw_box(x, y, width, height, colour, z_order = 0.0)
       self.draw_line(x, y, colour, x + width, y, colour, z_order)
       self.draw_line(x + width, y, colour, x + width, y + height, colour, z_order)
       self.draw_line(x, y, colour, x, y + height, colour, z_order)
       self.draw_line(x, y + height, colour, x + width, y + height, colour, z_order)
    end
    
    # writes a string to screen using custom colouring system
    # e.g. {red}this text is red and {black}this text is black
    def write(string, x, y, colour = :black, font = @fonts[:default])
      new_colour = false
      c = ""
      i = 0
      string.each_char do |char|
        if char == '{'
          new_colour = true
          c = ""
        elsif char == '}'
          new_colour = false
        elsif new_colour
          c += char
        else
          if c.length == 0
            colour = self.gosu_colour(colour)
        else
          colour = self.gosu_colour(c.to_sym)
        end
          font.draw(char, x + i, y, ZOrder::Text, 1, 1, colour)
          i += font.text_width(char)
        end
      end
    end
  
    # returns a Gosu::Color for a given colour symbol
    def gosu_colour(symbol)
      if symbol == :black
        Gosu::Color.new(0xff000000)
      elsif symbol == :white
        Gosu::Color.new(0xffffffff)
      elsif symbol == :red
        Gosu::Color.new(0xffff0000)
      elsif symbol == :blue
        Gosu::Color.new(0xff0000ff)
      elsif symbol == :green
        Gosu::Color.new(0xff00ff00)
      elsif symbol == :yellow
        Gosu::Color.new(0xffffff00)
      elsif symbol == :gray
        Gosu::Color.new(0xff808080)
      elsif symbol == :poison
        Gosu::Color.new(0xff009400)
      elsif symbol == :physical
        Gosu::Color.new(0xff333333)
      else
        Gosu::Color.new(0xff000000)  # unknown colour defaults to black
      end
    end
    
    # returns true if shift is being held down
    def shift_down
      if GameWindow.instance.button_down?(Gosu::KbRightShift) || GameWindow.instance.button_down?(Gosu::KbLeftShift)
        true
      else
        false
      end
    end
    
    # converts a Gosu::button_down id into a key object
    def get_key(id)
      if id == Gosu::KbUp then Key.new(:up, nil, :north)
      elsif id == Gosu::KbLeft then Key.new(:left, nil, :west)
      elsif id == Gosu::KbDown then Key.new(:down, nil, :south)
      elsif id == Gosu::KbRight then Key.new(:right, nil, :east)
      elsif id == Gosu::KbA && shift_down then Key.new(:A, 0)
      elsif id == Gosu::KbB && shift_down then Key.new(:B, 1)
      elsif id == Gosu::KbC && shift_down then Key.new(:C, 2)
      elsif id == Gosu::KbD && shift_down then Key.new(:D, 3)
      elsif id == Gosu::KbE && shift_down then Key.new(:E, 4)
      elsif id == Gosu::KbF && shift_down then Key.new(:F, 5)
      elsif id == Gosu::KbG && shift_down then Key.new(:G, 6)
      elsif id == Gosu::KbH && shift_down then Key.new(:H, 7)
      elsif id == Gosu::KbI && shift_down then Key.new(:I, 8)
      elsif id == Gosu::KbJ && shift_down then Key.new(:J, 9)
      elsif id == Gosu::KbK && shift_down then Key.new(:K, 10)
      elsif id == Gosu::KbL && shift_down then Key.new(:L, 11)
      elsif id == Gosu::KbM && shift_down then Key.new(:M, 12)
      elsif id == Gosu::KbN && shift_down then Key.new(:N, 13)
      elsif id == Gosu::KbO && shift_down then Key.new(:O, 14)
      elsif id == Gosu::KbP && shift_down then Key.new(:P, 15)
      elsif id == Gosu::KbQ && shift_down then Key.new(:Q, 16)
      elsif id == Gosu::KbR && shift_down then Key.new(:R, 17)
      elsif id == Gosu::KbS && shift_down then Key.new(:S, 18)
      elsif id == Gosu::KbT && shift_down then Key.new(:T, 19)
      elsif id == Gosu::KbU && shift_down then Key.new(:U, 20)
      elsif id == Gosu::KbV && shift_down then Key.new(:V, 21)
      elsif id == Gosu::KbW && shift_down then Key.new(:W, 22)
      elsif id == Gosu::KbX && shift_down then Key.new(:X, 23)
      elsif id == Gosu::KbY && shift_down then Key.new(:Y, 24)
      elsif id == Gosu::KbZ && shift_down then Key.new(:Z, 25)
      elsif id == 47 && shift_down then Key.new(:portal_down)
      elsif id == Gosu::KbA then Key.new(:a, 0)
      elsif id == Gosu::KbB then Key.new(:b, 1)
      elsif id == Gosu::KbC then Key.new(:c, 2)
      elsif id == Gosu::KbD then Key.new(:d, 3)
      elsif id == Gosu::KbE then Key.new(:e, 4)
      elsif id == Gosu::KbF then Key.new(:f, 5)
      elsif id == Gosu::KbG then Key.new(:g, 6)
      elsif id == Gosu::KbH then Key.new(:h, 7)
      elsif id == Gosu::KbI then Key.new(:i, 8)
      elsif id == Gosu::KbJ then Key.new(:j, 9)
      elsif id == Gosu::KbK then Key.new(:k, 10)
      elsif id == Gosu::KbL then Key.new(:l, 11)
      elsif id == Gosu::KbM then Key.new(:m, 12)
      elsif id == Gosu::KbN then Key.new(:n, 13)
      elsif id == Gosu::KbO then Key.new(:o, 14)
      elsif id == Gosu::KbP then Key.new(:p, 15)
      elsif id == Gosu::KbQ then Key.new(:q, 16)
      elsif id == Gosu::KbR then Key.new(:r, 17)
      elsif id == Gosu::KbS then Key.new(:s, 18)
      elsif id == Gosu::KbT then Key.new(:t, 19)
      elsif id == Gosu::KbU then Key.new(:u, 20)
      elsif id == Gosu::KbV then Key.new(:v, 21)
      elsif id == Gosu::KbW then Key.new(:w, 22)
      elsif id == Gosu::KbX then Key.new(:x, 23)
      elsif id == Gosu::KbY then Key.new(:y, 24)
      elsif id == Gosu::KbZ then Key.new(:z, 25)
      elsif id == Gosu::KbEscape then Key.new(:escape)
      elsif id == Gosu::KbSpace then Key.new(:space)
      elsif id == Gosu::KbReturn then Key.new(:return)
      end
    end

  end

end