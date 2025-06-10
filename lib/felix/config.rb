## Helper class that handles configs
require "./lib/felix/metadata"

module Felix

	class	Config

		## Contains all CL arguments already processed
		## Prevents weird intersection conditions
		@processed_arguments

		## Default options of the application
		DEFAULT_OPTIONS = {
				"columns" => 1,
				"default_font_size" => 12,
				"header1_size" => 32,
				"header2_size" => 28,
				"header3_size" => 20,
				"header4_size" => 18,
				"header5_size" => 16,
				"header6_size" => 14,
				"quote_size" => 14,
				"margin" =>  40,
				"font_normal" => "./assets/font/Unageo-Regular.ttf",
				"font_italic"=> "./assets/font/Unageo-Regular-Italic.ttf",
				"font_bold"=> "./assets/font/Unageo-ExtraBold.ttf",
				"font_bold_italic" => "./assets/font/Unageo-ExtraBold-Italic.ttf"
		}

		## Hash for custom command line argument calls
		CL_DATA = {
			"columns" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"default_font_size" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"header1_size" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"header2_size" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"header3_size" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"header4_size" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"header5_size" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"header6_size" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"margin" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args).to_i },
			"font_normal" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args) },
			"font_italic" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args) },
			"font_bold" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args) },
			"font_bold_italic" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args) },
			"page_layout" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args) },
			"input_files" => -> (command, args, index, cl_args) { cl_add_config(command, args, index, cl_args) },
		}

		### Command Line Arguments

		def self.cl_add_config(command,args, index, cl_args)
			cl_args[command] = args[index + 1]
		end

		### Config Loading

		## Loads default rendering options and config
		## Default arguments are loaded first,
		## then arguments loaded in ./default.cfg,
		## then command line arguments,
		## then finally any arguments defined in the metadata.

		def load_config(args)
			@processed_arguments = []
	
			# Felix metadata handler
			metadata = Felix::Metadata.new
			
			# load default options
			options = Marshal.load(Marshal.dump(DEFAULT_OPTIONS))
			
			# Loads the default configuation in default.cfg
			if File.file?("./default.cfg")
				
				config = metadata.get_metadata(File.read("./default.cfg")[0])
				config.keys.each do |key|
					options[key] = config[key]
				end
			end
			
			# Loads command line arguments
			cl_args = load_cl_args(args)
			
			cl_args.keys.each do |key|
				options[key] = cl_args[key]
			end

			options
			
		end

		# Loads command line arguments
		def load_cl_args(args)
			cl_args = {}
			
			index = 0
			
			args.each do |com|
				command = com.downcase
			
				if command.start_with?("--")
					command = command[2..]
				
					if !@processed_arguments.include?(command)
				
						if CL_DATA.key?(command)
						
							CL_DATA[command].call(command, args, index, cl_args)

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
