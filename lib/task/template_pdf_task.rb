require "task/default_task"
require "worker/template_pdf_writer"

module PetitFelix

	module Task
	
		class TemplatePDFTask < PetitFelix::Task::DefaultTask
		
			NAME = "template-pdf"

			## Default options of the application
			DEFAULT_OPTIONS = {
				"template" => "./templates/test.json",
				"output_file" => "./output/test.pdf"
			}
		
			def render_zine

				# Only continue if metadata has a title
				# Generates PDF
					
				pdf = PetitFelix::Worker::TemplatePDFWriter.new(
					page_layout: @metaoptions["page_layout"],
					print_scaling: @metaoptions["print_scaling"])

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
