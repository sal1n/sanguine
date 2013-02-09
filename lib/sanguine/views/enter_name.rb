module Sanguine

  module View
    
    class EnterName < View
    
      def initialize
        super(Point.new(380,105))
        file = File.dirname(__FILE__) + "/../../../resources/frame.png"
        @background = Gosu::Image.new(window, file, false)
      
        @text_field = TextField.new(window, window.fonts[:header], 390, 150)
        window.text_input = @text_field
      end
      
      def draw
      super
       @background.draw(300, 30, 0)
       window.write("<c=000000>What do you wish to be called?</c>", @x, @y, window.fonts[:header])
       @text_field.draw
     end
      
    end
    
    class TextField < Gosu::TextInput
      

      # Some constants that define our appearance.
      INACTIVE_COLOR  = 0xcc666666
      ACTIVE_COLOR    = 0x00ffffff
      CARET_COLOR     = 0xffffffff
      PADDING = 5

      attr_reader :x, :y

      def initialize(window, font, x, y)
        # TextInput's constructor doesn't expect any arguments.
        super()

        @window, @font, @x, @y = window, font, x, y

        # Start with a self-explanatory text in each field.
        self.text = ''
      end

      def draw
        # Depending on whether this is the currently selected input or not, change the
        # background's color.
        if @window.text_input == self then
          background_color = ACTIVE_COLOR
        else
          background_color = INACTIVE_COLOR
        end
       # @window.draw_quad(x - PADDING,         y - PADDING,          background_color,
        #                  x + width + PADDING, y - PADDING,          background_color,
           #               x - PADDING,         y + height + PADDING, background_color,
            #              x + width + PADDING, y + height + PADDING, background_color, 0)

        # Calculate the position of the caret and the selection start.
        pos_x = x + @font.text_width(self.text[0...self.caret_pos])
        sel_x = x + @font.text_width(self.text[0...self.selection_start])

        # Draw the selection background, if any; if not, sel_x and pos_x will be
        # the same value, making this quad empty.
       # @window.draw_quad(sel_x, y,          SELECTION_COLOR,
        #                  pos_x, y,          SELECTION_COLOR,
         #                 sel_x, y + height, SELECTION_COLOR,
          #                pos_x, y + height, SELECTION_COLOR, 0)

        # Draw the caret; again, only if this is the currently selected field.
        if @window.text_input == self then
          @window.draw_line(pos_x, y,          CARET_COLOR,
                            pos_x, y + height, CARET_COLOR, 0)
        end

   if @window.text_input == self then
        # Finally, draw the text itself!
        @window.write("<c=ffffff>#{self.text}</c>", x, y, @font)
     #   @font.draw(self.text, x, y, 0,1,1)
      end
      end

      # This text field grows with the text that's being entered.
      # (Without clipping, one has to be a bit creative about this ;) )
      def width
        @font.text_width(self.text)
      end

      def height
        @font.height
      end

    end
    
  end
  
end