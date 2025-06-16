require "felix/task_manager"

module PetitFelix

  class Generator
	
		## Renders all the files in the given directory.
		
		def render_files(wm, options)
			
			task = wm.get_task options["task"]

			if !task.nil?
				task.render_files options
			end

		end
		
	end
end
