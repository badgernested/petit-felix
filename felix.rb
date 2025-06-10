#!/usr/bin/env ruby
require "./lib/felix/generator"
require "./lib/felix/config"

module PetitFelix

	## The main class for petitfelix.
	## He handles everything with options passed as CLI arguments or an options hash.

	class Felix
	
		# cl_args - command line arguments passed from CLI
		# options - hash passed by developer containing default rendering options
		def initialize(cl_args: [], options: {})
	
			## Loads options from default values, ./default.cfg
			config = PetitFelix::Config.new
			loaded_options = config.load_config cl_args
			
			## Makes sure stuff passed by options variable overrides
			## any previous config loading
			options.each do |option|
				loaded_options[option] = options[option]
			end

			## Starts producing stuff
			felix_basic = PetitFelix::Generator.new
			felix_basic.render_files loaded_options
		
		end
		
	end
end

