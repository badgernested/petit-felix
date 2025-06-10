#!/usr/bin/env ruby
require "./lib/felix/generator"
require "./lib/felix/config"

module Felix

	class PetitFelix
	
		def start(args: {})
	
			## Loads options from default values, ./default.cfg and CLI
			config = Felix::Config.new
			options = config.load_config args

			## Starts producing stuff
			felix_basic = Felix::Generator.new
			felix_basic.render_files options
		
		end
		
	end
end

### Entry point for program

felix = Felix::PetitFelix.new
felix.start(args: ARGV)
