require "./source/felix/task/default_task"
require "./source/worker/basic_pdf_writer"

module Felix

	module Task
	
		class BasicPDFTask < Felix::Task::DefaultTask
		
			def render_zine options
				
				dir = options["output_dir"]
				
				
				page = File.read(options["filename"])
				
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
						
					pdf = Felix::Worker::BasicPDFWriter.new(
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
		
	end
	
end

end
