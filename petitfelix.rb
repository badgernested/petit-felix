#!/usr/bin/env ruby
require "./lib/felix/generator"
require "./lib/felix/config"

module PetitFelix

	class Felix
	
		def start(args: {})
	
			## Loads options from default values, ./default.cfg and CLI
			config = PetitFelix::Config.new
			options = config.load_config args

			## Starts producing stuff
			felix_basic = PetitFelix::Generator.new
			felix_basic.render_files options
		
		end
		
	end
end

### Entry point for program

felix = PetitFelix::Felix.new
felix.start(args: ARGV)
