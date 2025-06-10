require "./lib/felix/task/basic_pdf_task"

module Felix

  class Generator
	
		## Renders all the files in the given directory.
		
		def render_files(options)
		
			## debugging section
			input_path = "./md/*"
			output_path ="./output"
			
			if !options.key?("input_files")
				options["input_files"] = input_path
			end
			
			options["output_dir"] = output_path
			
			Felix::Task::BasicPDFTask.new.render_files options
		end
		
	end
end
