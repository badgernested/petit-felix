require "prawn"

## Custom column box that calculates bounding box

module Prawn
  class Document 
		class BoundingBox
      
      def initialize(document, parent, point, options = {})
        unless options[:width]
          raise ArgumentError, 'BoundingBox needs the :width option to be set'
        end

        @document = document
        @parent = parent
        @x, @y = point
        @base_x, @base_y = point
        @width = options[:width]
        @base_width = options[:width]
        @height = options[:height]
        @base_height = options[:height]
        @total_left_padding = 0
        @total_right_padding = 0
        @stretched_height = nil
        @margins = {}
        @base_margins = []
        if options.key?(:base_margins) && !options[:base_margins].nil?
        	@base_margins = options[:base_margins]
        end
				
      end
      
      def update_margins
      
      	@margins = {}
      
      	if @base_margins.count > 0
      		@margins = @base_margins[@document.page_count % @base_margins.count]
				end
      end
      
      def absolute_left
      	update_margins
      
      	margin = 0
      	
      	if !@margins.empty?
      		margin = @margins[:left]
      	end

      	@base_x + margin
      end
      
      def absolute_top
      	update_margins
      
      	margin = 0

      	if !@margins.empty?
      		margin = @margins[:top]
      	end
      	
      	@base_y - margin
      end
      
      def top
      	update_margins
      
      	margin = 0

      	if !@margins.empty?
      		margin = @margins[:top]
      	end
      
        height - margin
      end
      
      def width
      	update_margins
      
      	margin_left = 0
      	margin_right = 0
      	
      	if !@margins.empty?
      		margin_left = @margins[:left]
      		margin_right = @margins[:right]
      	end
  
      	
      	@base_width - (margin_left + margin_right)
      end
      
      def height
      	update_margins
      
      	margin_top = 0
      	margin_bottom = 0
      	
      	if !@margins.empty?
      		margin_top = @margins[:top]
      		margin_bottom = @margins[:bottom]
      	end
      
      	@base_height - (margin_top + margin_bottom)
      end
      
      # Increase the left padding of the bounding box.
      def add_left_padding(left_padding)
        @total_left_padding += left_padding
        @base_x += left_padding
        @base_width -= left_padding
      end

      # Decrease the left padding of the bounding box.
      def subtract_left_padding(left_padding)
        @total_left_padding -= left_padding
        @base_x -= left_padding
        @base_width += left_padding
      end

      # Increase the right padding of the bounding box.
      def add_right_padding(right_padding)
        @total_right_padding += right_padding
        @base_width -= right_padding
      end

      # Decrease the right padding of the bounding box.
      def subtract_right_padding(right_padding)
        @total_right_padding -= right_padding
        @base_width += right_padding
      end
      
		end
	end
end
