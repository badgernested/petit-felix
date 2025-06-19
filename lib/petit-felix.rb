#!/usr/bin/env ruby
require "felix/generator"
require "felix/config"
require "felix/task_manager"

# Main entry point of the program for batch outputting files

module PetitFelix

	class Output
	
		# cl_args - command line arguments passed from CLI
		# options - hash passed by developer containing default rendering options
		def initialize(cl_args: [], options: {})
		
			# Creates a new worker manager, which has all the worker stuff
			wm = PetitFelix::TaskManager.new
	
			## Loads options from default values, ./default.cfg
			config = PetitFelix::Config.new
			loaded_options = config.load_config wm, options, cl_args

			## Starts producing stuff
			PetitFelix::Generator.new.render_files wm, loaded_options
		
		end
		
	end

end

