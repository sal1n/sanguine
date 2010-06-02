module Sanguine
  
  # Basic 2D array.
  #
  class Array2D

    # constructor
    def initialize(columns, rows, default = nil)
      @data = Array.new(columns) { [] }
      rows.times { self.append_row }
      @default = default
    end

    def append_row
      @data.each { |c| c << @default }
    end

    def [](col, row=nil)
      if row 
        @data[col][row]
      else 
        @data[col].dup
      end
    end

    def []=(col, row, value)
      raise IndexError if col >= @data.size or row >= @data[0].size
      @data[col][row]=value
    end

    def each_col
      @data.each{ |c| yield c.dup }
    end

    def each
      @data.each do |c|
        c.each{ |i| yield i }
      end
    end

    def width
      @data.size
    end

    def height
      @data[0].size
    end

  end
  
end