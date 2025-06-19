require "task/template_pdf_task"
require "worker/template_pdf_writer"

module PetitFelix

	module Task
	
		class SinglePDFTask < PetitFelix::Task::DefaultTask
		
			# Task name
			def self.name 
			
				"pdf-single"
				
			end

			## Default options of the application
			def self.default_options
			
				return {
					"pdf" => "false"
				}
				
			end
		
			# Renders zine
			def render_zine
			
				# Only continue if metadata has a title
				# Generates PDF
			
				@metaoptions["pdf"] = false

				page = File.read(@metaoptions["filename"])
				
				# splits the page into parts for metadata and content
				
				# Felix metadata handler
				metadata_helper = PetitFelix::Metadata.new
					
				page_data = metadata_helper.split page
						
				metadata = @metaoptions.merge(metadata_helper.get_metadata(page_data[0]))

				# Always forces you to use this template
				@metaoptions["template"] = File.dirname(__FILE__) + "/../../templates/zine-single.json"

				if metadata["pdf"] == "true"
					
					pdf = PetitFelix::Worker::TemplatePDFWriter.new(
						page_layout: @metaoptions["page_layout"],
						print_scaling: @metaoptions["print_scaling"])

					@metaoptions["output_file"] = File.basename(File.basename(@metaoptions["filename"], ".md"), ".markdown") + ".pdf"

					pdf.set_options @metaoptions

					pdf.init_values @metaoptions, pdf

					pdf.read_template

					# Adds extra fonts
					#pdf.initialize_font
					
					# Outputs to file
					pdf.output
					
				end
			end
			
		
		end
	end
end
