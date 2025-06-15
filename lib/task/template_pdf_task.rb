require "task/default_task"
require "worker/template_pdf_writer"

module PetitFelix

	module Task
	
		class BasicPDFTask < PetitFelix::Task::DefaultTask
		
			NAME = "template_pdf"

			## Default options of the application
			DEFAULT_OPTIONS = {
			
			}
		
			def render_zine

				# Only continue if metadata has a title
					
				if @metadata.key?("title")
								
					# Parameters
						
					page_layout = :portrait
					print_scaling = :none
					
					if @metaoptions.key?("page_layout")
						page_layout = @metaoptions["page_layout"]
						
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

					pdf.set_options @metaoptions

					# Adds extra fonts
					
					pdf.initialize_font
					
					# Outputs to file
					pdf.output
					
				end
			end
			
		
	end
	
end

end
