module PetitFelix

	module Task
	
		class DefaultTask
		
			def render_zine options
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
								render_zine(options)
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
