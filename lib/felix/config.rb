## Helper class that handles configs
require "felix/metadata"

## Processes loaded options. Doesn't actually store them, though.

module PetitFelix

	class	Config

		## Contains all CL arguments already processed
		## Prevents weird intersection conditions
		@processed_arguments

		# Global defaults
		DEFAULT_OPTIONS = {
			"image_dir" => (File.join("assets","images")),
			"input_files" => (File.join("md","*")),
			"output_dir" => (File.join("output")),
			"task" => "pdf-single",
		}

		## Hash for custom command line argument calls
		CL_DATA = {

		}

		### Command Line Arguments

		def cl_add_config command, args, index, cl_args
			cl_args[command] = args[index + 1]
		end

		### Config Loading

		## Loads default rendering options and config
		## Default arguments are loaded first,
		## then arguments loaded in ./default.cfg,
		## then command line arguments,
		## then finally any arguments defined in the metadata.

		def load_config wm, passed_args, args
		
			@processed_arguments = []
	
			# Felix metadata handler
			metadata = PetitFelix::Metadata.new
			
			# load global default options
			default_options = Marshal.load(Marshal.dump(DEFAULT_OPTIONS))
			
			# Loads the default configuation in default.cfg
			
			default_config = {}
			
			default_file = File.join("default.cfg")
			
			if File.file? default_file
				
				default_config = metadata.get_metadata(File.read default_file)
			end
			
			# Loads command line arguments
			cl_args = load_cl_args args
			
			# Loads default worker options
			worker = ""
			worker_options = nil
			
			# Gets the task to run.
			
			if default_options.key? "task"
				worker = default_options["task"]
			end
			
			if default_config.key? "task"
				worker = default_config["task"]
			end
			
			if cl_args.key? "task"
				worker = cl_args["task"]
			end
			
			if passed_args.key? "task"
				worker = passed_args["task"]
			end
			
			# Loads the worker based on the task.
			
			if worker != ""
				worker_options = Marshal.load(Marshal.dump(wm.get_task_options worker))
			end

			# Now, assemble the options in order
			# First, default options
			options = default_options
			
			# Then loading default worker args
			if !worker_options.nil?
				worker_options.keys.each do |key|
					options[key] = worker_options[key]
				end
			end
			
			# Then loading default config file
			default_config.keys.each do |key|
				options[key] = default_config[key]
			end
				
			# Then loading CLI arguments
			cl_args.keys.each do |key|
				options[key] = cl_args[key]
			end
			
			# Then loading passed arguments
			passed_args.keys.each do |key|
				options[key] = passed_args[key]
			end

			options
		end

		# Loads command line arguments
		def load_cl_args args
			cl_args = {}
			
			index = 0
			
			args.each do |com|
			
				command = com.downcase
			
				if command.start_with? "--"
					command = command[2..]
				
					if !@processed_arguments.include? command
				
						if CL_DATA.key? command
						
							CL_DATA[command].call command, args, index, cl_args

						else
						
							cl_add_config command, args, index, cl_args

						end
						
						@processed_arguments << command
						
					end
				end
				
				index+=1
			end

			cl_args
		end
		
	end
end
