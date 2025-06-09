require "./source/felix/task/basic_pdf_task"

module Felix

  class Generator
	
		## Renders all the files in the given directory.
		
		def render_files(options)
		
			## debugging section
			input_path = "./md"
			output_path ="./output"
		
			# this should be changed to render from a selection statement
			site_list = Dir.entries(input_path)
			
			options["input_dir"] = input_path
			options["output_dir"] = output_path
			
			Felix::Task::BasicPDFTask.new.render_files options
		end
		
	end
end
