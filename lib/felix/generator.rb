require "felix/task_manager"

module PetitFelix

  class Generator
	
		## Renders all the files in the given directory.
		
		def render_files(wm, options, override_options: {})
			
			task = wm.get_task options["task"]
			
			default_options = wm.get_task_options options["task"]
			
			default_options = default_options.merge(options)

			if !task.nil?
				task.render_files default_options, override_options
			end

		end
		
	end
end
