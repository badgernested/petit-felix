require "felix/task/basic_pdf_task"
require "felix/error"

module PetitFelix

  class Generator
	
		WORKERS = {
			# Basic PDF 
			"basic_pdf" => PetitFelix::Task::BasicPDFTask.new,
		}
	
		## Renders all the files in the given directory.
		
		def render_files(options)
		
			## debugging section
			input_path = "./md/*"
			output_path ="./output"
			
			if !options.key?("input_files")
				options["input_files"] = input_path
			end
			
			if !options.key?("output_dir")
				options["output_dir"] = output_path
			end
			
			if WORKERS.key?(options["worker"].downcase)
				WORKERS[options["worker"].downcase].render_files options
			else
				text = "worker " + options["worker"].downcase + " not found. Make sure the variable \"worker\" is set correctly in your configuration settings. Available workers: "
			
				WORKERS.keys.each do |key|
					text += "\n  " + key
				end
			
				PetitFelix::Error.new.print_err text
			end
		end
		
	end
end
