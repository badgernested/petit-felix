require "prawn"
require 'fileutils'
require "prawndown-ext"

module PdfFelixBasic

  class	PrawnExtd < Prawn::Document
  
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
  
  	DEFAULT_OPTIONS = {
  		"columns" => 1,
  		"default_font_size" => 12,
		"header1_size" => 32,
		"header2_size" => 28,
		"header3_size" => 20,
		"header4_size" => 18,
		"header5_size" => 16,
		"header6_size" => 14,
		"margin" =>  40,
		"font_normal" => "./assets/font/Unageo-Regular.ttf",
		"font_italic"=> "./assets/font/Unageo-Regular-Italic.ttf",
		"font_bold"=> "./assets/font/Unageo-ExtraBold.ttf",
		"font_bold_italic" => "./assets/font/Unageo-ExtraBold-Italic.ttf"
	}
	
	def strip_data(input)
		input = input.split("---")
		if input.count > 1
			input = input.reject! { |s| s.nil? || s.empty? }
		end
		input
	end

	def get_metadata(input)
		array = input.lines

		metadata = {}
		
		array.each do |set|
			if set.count(":") >= 1
				data = set.split(":")
				index = data[0].strip.downcase
				metadata[index] = data[1].strip
			end
		end
		metadata
	end

	def gen_zine(page, dir, options: nil,
		title: true,
		back: true)
		
		
		# splits the page into parts for metadata and content
			
		page_data = strip_data page
			
		metadata = get_metadata page_data[0]
			
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
				
			pdf = PrawnExtd.new(
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
	
	def get_options
	
		# load default options
		options = Marshal.load(Marshal.dump(DEFAULT_OPTIONS))
		
		# Loads the default configuation in default.cfg
		if File.file?("./default.cfg")
			
			config = get_metadata(strip_data(File.read("./default.cfg"))[0])
			config.keys.each do |key|
				options[key] = config[key]
			end
		end
		
		options
	
	end

	def create_pdf(file, save_path: "./output", options: {})
		loaded_options = Marshal.load(Marshal.dump(options))

		content = File.read("./md/" + file)

		# 1 column text zine, portrait
		gen_zine(content, save_path, options: loaded_options)
	end
	
	## Renders all the files in the given directory.
	
	def render_all_files(input_path: "./md", output_path:"./output")
		site_list = Dir.entries(input_path)
		loaded_options = get_options
		
		site_list.each do |page|
		
			if File.file?(input_path + "/" + page)
				create_pdf(page, save_path: output_path, options: loaded_options)
				end
			end
	end

	def initialize
		
	end
		
end
end
