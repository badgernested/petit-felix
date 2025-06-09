require "prawn"
require 'fileutils'
require "prawndown-ext"
require "./source/metadata_handler"

module PdfFelixBasic

  class	PDFWriter < Prawn::Document
  
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
				var = "./assets/images/" + metadata["back_cover_image"]
				
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
				var = "./assets/images/" + metadata["front_cover_image"]
				
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
  
  end

  class Generator

	def make_zine(page, dir,
		title: true,
		back: true)
		
		options = Marshal.load(Marshal.dump(@options))
		page = File.read(page)
		
		# splits the page into parts for metadata and content
		
		# Felix metadata handler
		metadata_helper = Felix::Metadata.new
			
		page_data = metadata_helper.split page
				
		metadata = metadata_helper.get_metadata page_data[0]
			
		content = page_data[1]
		
		# stores options + metadata. metadata overrides options.
		metaoptions = {}
		
		options.keys.each do |key|
			metaoptions[key] = options[key]
		end
		
		metadata.keys.each do |key|
			metaoptions[key] = metadata[key]
		end
		
		# Only continue if metadata has a title
			
		if metadata.key?("title")
						
			# Parameters
				
			margin = 25
			page_layout = :portrait
			print_scaling = :none
			columns = 1

			if metaoptions.key?("margin")
				margin = metaoptions["margin"].to_i
			end
			
			if metaoptions.key?("columns")
				columns = metaoptions["columns"].to_i
			end
			
			if metaoptions.key?("page_layout")
				page_layout = metaoptions["page_layout"]
				
				if page_layout.is_a? String
					if page_layout.include?("portrait")
						page_layout = :portrait
					else 
						if page_layout.include?("landscape")
						page_layout = :landscape
						end
					end
				end
			end
			
			# Calculated values
				
			half_margin = (margin * 0.5).floor()
			
			# Generates PDF
				
			pdf = PDFWriter.new(
				page_layout: page_layout,
				print_scaling: print_scaling)

			pdf.font_families.update("OpenSans" => {
			:normal => metaoptions["font_normal"],
			:italic => metaoptions["font_italic"],
			:bold => metaoptions["font_bold"],
			:bold_italic => metaoptions["font_bold_italic"]
			})

			pdf.font "OpenSans"
			
			# If the title is generated
			if metaoptions.key?("front_cover")
				if metaoptions["front_cover"]
					pdf.title_page(pdf, metaoptions)
					pdf.start_new_page()
				end
			end
			
			# content generation
			pdf.font_size(metaoptions["default_font_size"].to_i)
			
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
			
			# If the back is generated
			if metaoptions.key?("back_cover")
				if metaoptions["back_cover"]
					pdf.start_new_page()
					pdf.back_page(pdf, metaoptions)
				end
			end
			

			FileUtils.mkdir_p dir
			pdf.render_file(dir + "/" + metadata["title"].gsub(/[^\w\s]/, '').tr(" ", "_") + '.pdf')
		end
	end
	
	## Renders all the files in the given directory.
	
	def render_all_files(input_path: "./md", output_path:"./output")
		site_list = Dir.entries(input_path)
		
		site_list.each do |page|
		
			filename = input_path + "/" + page
		
			if File.file?(filename)
				make_zine(filename, output_path)
				end
			end
	end
	
	def set_base_options(options)
		@options = options
	end

	def initialize
		
	end
		
end
end
