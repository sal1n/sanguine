module Sanguine
  
  module State
    
    # base class for all states, a hash so that views can have easy variable access
    # 
    # @todo is subclassing Hash the nicest solution here?  maybe make states 
    # indepedent of views...
    #
    class State < Hash
      
      include HandyMethods
      
      attr_accessor :views
      
      def initialize
        @views = Array.new
      end

      # need a post initialisation method to allow instant state switching
      # put all validation etc here!
      def activate
      end
      
      # pass in the Key object created by Gosu button_down
      def command(key)
      end
      
      # we don't want to marshal the views esp. since Gosu::Image doesn't
      # marshal, so just override here and leave blank!
      def marshal_dump
      end
      
      def marshal_load(data)
      end
      
    end
    
  end
  
end