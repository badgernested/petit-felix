require "felix/metadata"

module PetitFelix

	module Task
	
		class DefaultTask
		
			def prepare_options options
				page = File.read(options["filename"])
				
				# splits the page into parts for metadata and content
				
				# Felix metadata handler
				metadata_helper = PetitFelix::Metadata.new
					
				page_data = metadata_helper.split page
						
				@metadata = metadata_helper.get_metadata page_data[0]
					
				@content = page_data[1]
				
				# stores options + metadata. metadata overrides options.
				@metaoptions = {}
				
				options.keys.each do |key|
					@metaoptions[key] = options[key]
				end
				
				@metadata.keys.each do |key|
					@metaoptions[key] = @metadata[key]
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
