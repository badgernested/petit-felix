require "worker/pdf_writer/bounding_box"

module Prawn
  class Document 
		class ColumnBox < BoundingBox
		
      def bare_column_width
      	update_margins
      
      	margin_left = 0
      	margin_right = 0
      	
      	if !@margins.empty?
      		margin_left = @margins[:left]
      		margin_right = @margins[:right]
      	end
      
        ((@width - (margin_left + margin_right)) - (@spacer * (@columns - 1))) / @columns
      end

      # Moves to the next column or starts a new page if currently positioned at
      # the rightmost column.
      #
      # @return [void]
      def move_past_bottom
        @current_column = (@current_column + 1) % @columns
        @document.y = absolute_top
        if @current_column.zero?
          if @reflow_margins
            @y = @parent.absolute_top
          end
          @document.start_new_page
        end
      end

    end
	end
end
