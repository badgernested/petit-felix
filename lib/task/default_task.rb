require "felix/metadata"

module PetitFelix

	module Task
	
		class DefaultTask
		
			def self.name 
				""
			end

			## Default options of the application
			def self.default_options
				return {}
			end
		
			def prepare_options options
			
				# stores options + metadata. metadata overrides options.
				@metaoptions = {}
				
				options.keys.each do |key|
					@metaoptions[key] = options[key]
				end
				
				# Loads proper values from strings for certain params
				page_layout = :portrait
				print_scaling = :none
				
				if @metaoptions.key?("page_layout")
					page_layout = @metaoptions["page_layout"].to_sym
				end
				
			end
		
			def render_zine
				print "render_zine() not implemented\n"
			end
		
			def render_files options
				if options.key?("input_files")
					site_list = options["input_files"].split(",")
				end
				
				site_list.each do |page|
				
					file_list = Dir[page.strip].select { |path| File.file?(path) }
				
					if !file_list.empty?
				
						file_list.each do |file|
							options["filename"] = file.strip
							
							if File.file?(options["filename"])
								prepare_options options
								render_zine
							end
						
						end
						
					else
						if File.file?(page)
							render_zine(page)
						end
					end
				end

		end
				
		end
	end
end
