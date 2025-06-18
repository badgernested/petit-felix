require "task/template_pdf_task"
require "worker/template_pdf_writer"

module PetitFelix

	module Task
	
		class SinglePDFTask < PetitFelix::Task::DefaultTask
		
			def self.name 
				"pdf-single"
			end

			## Default options of the application
			def self.default_options
				return {
					"template" => "./templates/zine_single.json"
				}
			end
		
			def render_zine

				# Only continue if metadata has a title
				# Generates PDF
					
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
