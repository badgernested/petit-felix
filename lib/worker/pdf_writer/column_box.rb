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
    end
	end
end
