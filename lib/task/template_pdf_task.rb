require "task/default_task"
require "worker/template_pdf_writer"

module PetitFelix

	module Task
	
		class TemplatePDFTask < PetitFelix::Task::DefaultTask
		
			def self.name
			
				"template-pdf"
				
			end

			## Default options of the application
			def self.default_options 
			
				return {
					"template" => (File.join(File.dirname(__FILE__),"..","..","templates","test.json")),
					"output_file" => "test.pdf"
				}
				
			end
		
			def render_zine

				# Only continue if metadata has a title
				# Generates PDF
					
				pdf = PetitFelix::Worker::TemplatePDFWriter.new(
					page_layout: @metaoptions["page_layout"],
					print_scaling: @metaoptions["print_scaling"])

				pdf.set_options @metaoptions

				pdf.init_values @metaoptions, pdf

				pdf.read_template
				
				# Outputs to file
				pdf.output

			end
			
		
		end
		
	end

end
