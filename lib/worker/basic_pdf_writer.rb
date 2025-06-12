require "prawn"
require 'fileutils'
require "prawndown-ext"
require "felix/metadata"

module PetitFelix
	module Worker

		class	BasicPDFWriter < Prawn::Document
		
			def page_numbering(page)
			
				font_size(12)
				
				string = page.title + ": " ' <page>/<total>'
				
			# Green page numbers 1 to 7
			options = {
				at: [0, 0],
				width: bounds.width,
				align: :right,
				start_count_at: 1,
				color: '000000'
			}
			options[:page_filter] = ->(pg) { pg > 1 }
			
			number_pages string, options
		
			end
		
			def back_page(pdf, metadata)
			
			# draw art
			
			box_width = 128
			
			pdf.font_size(24)
			pdf.bounding_box([pdf.bounds.width * 0.5 - 64, pdf.cursor - 500], 
			width: pdf.bounds.width - 100 - box_width,
			height: box_width) do
			
				if metadata.key?("back_cover_image")
					var = PetitFelix::Metadata.new.get_image_location(metadata["image_dir"], metadata["back_cover_image"])
					
					if File.file?(var)
						pdf.image(var,
						width: box_width,
						height: box_width,
						align: :center)
					end
				end
				#transparent(0.5) { pdf.stroke_bounds }
			end
			
			# draw name
			
			pdf.font_size(20)
			pdf.bounding_box([50, pdf.cursor - 20], 
			width: pdf.bounds.width - 100,
			height: 40) do
				if metadata.key?("author_back")
					pdf.text_box(metadata["author_back"],
					align: :center)
				end
				#pdf.transparent(0.5) { pdf.stroke_bounds }
			end
			
			end
		
	 	def title_page(pdf, metadata)
			# draw title text
			pdf.font_size(36)
			pdf.bounding_box([25, pdf.cursor - 20], 
			width: pdf.bounds.width - 50,
			height: 150) do
				pdf.text_box(metadata["title"],
				align: :center,
				style: :bold)
				#pdf.transparent(0.5) { pdf.stroke_bounds }
			end
			
			# draw art
			
			box_width = pdf.bounds.width - 100
			
			pdf.font_size(24)
			pdf.bounding_box([50, pdf.cursor], 
			width: box_width,
			height: box_width) do
			
				if metadata.key?("front_cover_image")
					var = PetitFelix::Metadata.new.get_image_location(metadata["image_dir"], metadata["front_cover_image"])
					
					if File.file?(var)
						pdf.image(var,
						width: box_width,
						height: box_width)
					end
				end
				#pdf.transparent(0.5) { pdf.stroke_bounds }
			end
			
			# draw name
			
			pdf.font_size(24)
			pdf.bounding_box([50, pdf.cursor - 10], 
			width: pdf.bounds.width - 100,
			height: 40) do
				if metadata.key?("author")
					pdf.text_box(metadata["author"],
					align: :center)
				end
				#pdf.transparent(0.5) { pdf.stroke_bounds }
			end
			
			pdf.font_size(16)
			pdf.bounding_box([50, pdf.cursor], 
			width: pdf.bounds.width - 100,
			height: 80) do
				pdf.text_box("Original Publication: " + metadata["date"],#.strftime('%e %B, %Y'),
				align: :center)
				#pdf.transparent(0.5) { pdf.stroke_bounds }
			end
		end
		
		def main_block(pdf, options, content)
			margin = 25
			columns = 1
			
			if options.key?("margin")
				margin = options["margin"].to_i
			end
			
			if options.key?("columns")
				columns = options["columns"].to_i
			end
		
			half_margin = (margin * 0.5).floor()
		
			# content generation
			pdf.font_size(options["default_font_size"].to_i)
			
			if columns == 1
				pdf.bounding_box([half_margin, pdf.cursor - half_margin],
					width: pdf.bounds.width-margin,
					height: pdf.bounds.height - margin) do
				
					pdf.markdown(content, options: options)
				end
			else
				pdf.column_box([half_margin, pdf.cursor - half_margin],
					columns: columns,
					width: pdf.bounds.width-margin,
					height: pdf.bounds.height - margin) do
				
					pdf.markdown(content, options: options)
				end
			end
		end

	end

	end
end
