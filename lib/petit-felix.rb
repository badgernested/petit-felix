#!/usr/bin/env ruby
require "felix/generator"
require "felix/config"

module PetitFelix

	class Output
	
		# cl_args - command line arguments passed from CLI
		# options - hash passed by developer containing default rendering options
		def initialize(cl_args: [], options: {})
	
			## Loads options from default values, ./default.cfg
			config = PetitFelix::Config.new
			loaded_options = config.load_config cl_args

			## Makes sure stuff passed by options variable overrides
			## any previous config loading
			options.keys.each do |option|
				loaded_options[option] = options[option]
			end

			## Starts producing stuff
			felix_basic = PetitFelix::Generator.new
			felix_basic.render_files loaded_options
		
		end
		
	end

end

