require "prawn"
require 'fileutils'
require "prawndown-ext"
require "felix/metadata"
require "worker/pdf_writer"

module PetitFelix
	module Worker

		class	BasicPDFWriter < PetitFelix::Worker::DefaultPDFWriter

			# Initializes fonts
			def initialize_font
			
				# Fonts that must always be defined
				fonts = [
					"quote",
					"header1",
					"header2",
					"header3",
					"header4",
					"header5",
					"header6",
					"front_default", # Default title text
					"back_default", # Default title text
					"paginator",
				]
				
				fonts_special_default = {
					"front_title" => "front_default",	# Title Text
					"front_author" => "front_default",	# Author Text
					"front_date" => "front_default", # Date Text
					"front_publish" => "front_default", # Publication Text
					"back_author" => "back_default", # Publication Text
					"back_publish" => "back_default", # Publication Text
				}
			
				add_font "default"
				
				# Adds the fonts in the options
				fonts.each do |key|
					add_font key
					@options[key +"_font"] = key
				end
				
				# Adds special fonts with custom default fonts
				fonts_special_default.keys.each do |key|
					add_font key, default_font: fonts_special_default[key]
					@options[key +"_font"] = key
				end
				
			end
		
			# Draws page numbering
			
			def page_numbering
			
				if @options.key?("paginator")
					if @options["paginator"]
					
						font "paginator"
					
						font_size(@options["paginator_size"].to_i)
						
						string = @options["title"] + ": " ' <page>'
						
						page_start_count = @options["paginator_start_count"].to_i
						page_start = @options["paginator_start"].to_i
						
						align_odd = :left
						align_even = :right
						
						if @options["front_extra_page"]
							page_start += 1
							align_odd = :right
							align_even = :left
						end
						
						if @options["paginator_alternate"]
						
							odd_options = {
								at: [0, 0],
								width: bounds.width,
								align: align_odd,
								start_count_at: page_start_count,
							}
							
							odd_options[:page_filter] = ->(pg) { pg > page_start && pg % 2 == 1 }
							
							even_options = {
								at: [0, bounds.left],
								width: bounds.width,
								align: align_even,
								start_count_at: page_start_count + 1,
							}
							
							even_options[:page_filter] = ->(pg) { pg > page_start && pg % 2 == 0 }
							
							number_pages string, odd_options
							number_pages string, even_options
							
						else
						
							options = {
								at: [0, 0],
								width: bounds.width,
								align: :right,
								start_count_at: page_start_count,
								color: '000000'
							}
							options[:page_filter] = ->(pg) { pg > page_start }
							
							number_pages string, options
							
						end
						
					end
				end
			end
		
			# Draws back page
			def back_page
			
				if @options.key?("back_cover")
					if @options["back_cover"]
						if @options.key?("back_extra_page") && @options["back_extra_page"]
							start_new_page()
						end
					
						start_new_page()
			
						font "back_default"
					
						# draw end text, can be markdown
						font_size(@options["back_text_size"].to_i)
						
						margin = @options["back_text_margin"].to_i
						
						half_margin = (margin * 0.5).floor
						
						bounding_box([half_margin, cursor - 20 - half_margin], 
						width: bounds.width - margin,
						height: 300 - margin) do
							markdown(@options["back_text"], options: @options)
							#transparent(0.5) { stroke_bounds }
						end
					
						# draw art
						
						box_width = 128
						
						bounding_box([bounds.width * 0.5 - 64, cursor - 180], 
						width: bounds.width - 100 - box_width,
						height: box_width) do
						
							if @options.key?("back_cover_image")
								var = PetitFelix::Metadata.new.get_image_location(@options["image_dir"], @options["back_cover_image"])
								
								if File.file?(var)
									image(var,
									width: box_width,
									height: box_width,
									align: :center)
								end
							end
							#transparent(0.5) { stroke_bounds }
						end
						
						# draw name
						
						font "back_author"
						
						font_size(@options["back_author_size"].to_i)
						bounding_box([50, cursor - 20], 
						width: bounds.width - 100,
						height: 40) do
							if @options.key?("back_author")
								text_box(@options["back_author"],
								align: :center)
							end
							#transparent(0.5) { stroke_bounds }
						end
						
						font "back_publish"
						
						font_size(@options["back_publisher_size"].to_i)
						bounding_box([25, cursor - 60], 
						width: bounds.width - 50,
						height: 32) do
						
							text_box(@options["back_publisher"],
							align: :center)
							#transparent(0.5) { stroke_bounds }
						end
				
					end
				end
			end
		
		
		# Draws title page
	 	def title_page
	 	
			if @options.key?("front_cover")
				if @options["front_cover"]
	 	
	 				font "front_title"
	 	
					# draw title text
					font_size(@options["front_title_size"].to_i)
					bounding_box([25, cursor ], 
					width: bounds.width - 50,
					height: 250) do
						text_box(@options["title"],
						align: :center,
						style: :bold)
						#transparent(0.5) { stroke_bounds }
					end
					
					# draw art
					
					box_width = bounds.width - 150
					
					bounding_box([50, cursor + 10], 
					width: box_width,
					height: box_width) do
					
						if @options.key?("front_cover_image")
							var = PetitFelix::Metadata.new.get_image_location(@options["image_dir"], @options["front_cover_image"])
							
							if File.file?(var)
								image(var,
								width: box_width,
								height: box_width)
							end
						end
						#transparent(0.5) { stroke_bounds }
					end
					
					font "front_author"
					
					# draw author
					
					font_size(@options["front_author_size"].to_i)
					bounding_box([50, cursor - 10], 
					width: bounds.width - 100,
					height: 30) do
						if @options.key?("author")
							text_box(@options["author"],
							align: :center)
						end
						#transparent(0.5) { stroke_bounds }
					end
					
					font "front_date"
					
					font_size(@options["front_date_size"].to_i)
					bounding_box([50, cursor], 
					width: bounds.width - 100,
					height: 30) do
						text_box("Original Publication: " + @options["date"],#.strftime('%e %B, %Y'),
						align: :center)
						#transparent(0.5) { stroke_bounds }
					end
					
					font "front_publish"
					
					font_size(@options["front_publisher_size"].to_i)
					bounding_box([25, cursor - 20], 
					width: bounds.width - 50,
					height: 32) do
					
						text_box(@options["front_publisher"],
						align: :center)
						#transparent(0.5) { stroke_bounds }
					end
					
					start_new_page()
					if @options.key?("front_extra_page") && @options["front_extra_page"]
						start_new_page()
					end
					
				end
			end
			
		end
		
		# Draws the main block of content
		def main_block(content)
			font "default"
		
			margin = 25
			columns = 1
			
			if @options.key?("margin")
				margin = @options["margin"].to_i
			end
			
			if @options.key?("columns")
				columns = @options["columns"].to_i
			end
		
			half_margin = (margin * 0.5).floor()
		
			# content generation
			font_size(@options["default_font_size"].to_i)
			
			if columns == 1

				bounding_box([half_margin, cursor - half_margin],
					width: bounds.width-margin,
					height: [bounds.height - 20 - margin, bounds.height - margin].min) do
					markdown(content, options: @options)
				end
				
			else
			
				column_box([half_margin, cursor - half_margin],
					columns: columns,
					width: bounds.width-margin,
					height: [bounds.height - 20 - margin, bounds.height - margin].min) do
					
					markdown(content, options: @options)
					
				end
			end
		end

	end

	end
end
