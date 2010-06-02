module Sanguine

  module MapGeneration
    
    class BSPNode

      # child nodes
      attr_accessor :parent, :depth
      attr_accessor :split_orientation
      attr_accessor :left, :right
      attr_accessor :x, :y
      attr_accessor :width, :height

      # constructor
      def initialize(x, y, width, height, parent = nil)
        @x, @y, @width, @height, @parent = x, y, width, height, parent
        if @parent != nil
          @depth = @parent.depth + 1
        else
          @depth = 0
        end
      end

      def to_a(array = Array.new)
        array << self
        if @left != nil
          @left.to_a(array)
        end
        if @right != nil
          @right.to_a(array)
        end
        array
      end

      # partition node
      def partition
        # don't partition if node is too small
        if self.smallest < MapGeneration::SmallestPartitionSize
          return
        else
          if split_direction == :horizontal
            split = split_horizontal.to_i
            @left = BSPNode.new(@x, @y, split, @height, self)
            @right = BSPNode.new(@x + split, @y, @width - split, @height, self)
          else  # :vertical split
            split = split_vertical.to_i
            @left = BSPNode.new(@x, @y, @width, split, self)
            @right = BSPNode.new(@x, @y + split, @width, @height - split, self)
          end
          # recursive partioning
          @left.partition
          @right.partition
        end
      end

      def smallest
        if @width <= @height
          @width
        else
          @height
        end
      end

      def leaf_node?
        if @left.nil? && @right.nil?
          true
        else
          false
        end
      end

      def split_direction
        if @width / @height > MapGeneration::MaxPartitionSizeRatio
          @split_orientation = :horizontal
        elsif @height / @width > MapGeneration::MaxPartitionSizeRatio
          @split_orientation = :vertical
        elsif rand(2) == 0
          @split_orientation = :horizontal
        else
          @split_orientation = :vertical
        end
      end

      def split_horizontal
        @width  * (0.5 - (rand * MapGeneration::HomogeneityFactor))
      end

      def split_vertical
        @height  * (0.5 - (rand * MapGeneration::HomogeneityFactor))
      end 

      def to_s
        "(#{@x}, #{@y}) width #{@width} height #{@height} id #{self.__id__} parent #{@parent.__id__}"
      end

    end
    
  end
  
end
