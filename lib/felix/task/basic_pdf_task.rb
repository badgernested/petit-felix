require "felix/task/default_task"
require "worker/basic_pdf_writer"

module PetitFelix

	module Task
	
		class BasicPDFTask < PetitFelix::Task::DefaultTask
		
			# Adds a font to the pdf document
			def add_font pdf, metaoptions, type

					if metaoptions.key?(type + "_font_normal")
						font_normal = type + "_font_normal"
						font_italic = type + "_font_normal"
						font_bold = type + "_font_normal"
						font_bold_italic = type + "_font_normal"
						
						if metaoptions.key?(type + "_font_italic")
							font_italic = type + "_font_italic"
						end
						if metaoptions.key?(type + "_font_bold")
							font_bold = type + "_font_bold"
						end
						if metaoptions.key?(type + "_font_bold_italic")
							font_bold_italic = type + "_font_bold_italic"
						end
					
						pdf.font_families.update(type => {
							:normal => metaoptions[font_normal],
							:italic => metaoptions[font_italic],
							:bold => metaoptions[font_bold],
							:bold_italic => metaoptions[font_bold_italic]
						})
						
					else
					
						pdf.font_families.update(type => {
							:normal => metaoptions["font_normal"],
							:italic => metaoptions["font_italic"],
							:bold => metaoptions["font_bold"],
							:bold_italic => metaoptions["font_bold_italic"]
						})
						
					end
			end
		
			def render_zine options
				
				# Options that are always added for this task
				options["quote_font"] = "quote"
				options["header1_font"] = "header1"
				options["header2_font"] = "header2"
				options["header3_font"] = "header3"
				options["header4_font"] = "header4"
				options["header5_font"] = "header5"
				options["header6_font"] = "header6"
				
				dir = options["output_dir"]
				
				
				page = File.read(options["filename"])
				
				# splits the page into parts for metadata and content
				
				# Felix metadata handler
				metadata_helper = PetitFelix::Metadata.new
					
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
						
					page_layout = :portrait
					print_scaling = :none
					
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

					# Generates PDF
						
					pdf = PetitFelix::Worker::BasicPDFWriter.new(
						page_layout: page_layout,
						print_scaling: print_scaling)

					pdf.font_families.update("OpenSans" => {
					:normal => metaoptions["font_normal"],
					:italic => metaoptions["font_italic"],
					:bold => metaoptions["font_bold"],
					:bold_italic => metaoptions["font_bold_italic"]
					})
					
					add_font pdf, metaoptions, "quote"
					
					add_font pdf, metaoptions, "header1"
					add_font pdf, metaoptions, "header2"
					add_font pdf, metaoptions, "header3"
					add_font pdf, metaoptions, "header4"
					add_font pdf, metaoptions, "header5"
					add_font pdf, metaoptions, "header6"
					
					# End quote font
					
					pdf.font "OpenSans"
					
					# If the title is generated
					if metaoptions.key?("front_cover")
						if metaoptions["front_cover"]
							pdf.title_page(pdf, metaoptions)
							pdf.start_new_page()
							if metaoptions.key?("front_extra_page") && metaoptions["front_extra_page"]
								pdf.start_new_page()
							end
						end
					end
					
					# Does the main content
					pdf.main_block(pdf, metaoptions, content)
					
					# If the back is generated
					if metaoptions.key?("back_cover")
						if metaoptions["back_cover"]
							if metaoptions.key?("back_extra_page") && metaoptions["back_extra_page"]
								pdf.start_new_page()
							end
						
							pdf.start_new_page()
							pdf.back_page(pdf, metaoptions)
						end
					end
					

					FileUtils.mkdir_p dir
					pdf.render_file(dir + "/" + metadata["title"].gsub(/[^\w\s]/, '').tr(" ", "_") + '.pdf')
				end
			end
		
	end
	
end

end
