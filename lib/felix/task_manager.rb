## This class maintains all of the available tasks in the system.
require "felix/error"

module PetitFelix
	class TaskManager
		
		# Gets the list of tasks loaded
		def initialize
			@error_printer = PetitFelix::Error.new
			@task_list = {}
			
			load "task/template_pdf_task.rb"
		
			task_list = PetitFelix::Task.constants.select {|c| PetitFelix::Task.const_get(c).is_a? Class}

			task_list.delete(:DefaultTask)
			
			task_list.each do |task|
				task_instance = PetitFelix::Task.const_get(task)
			
				task_obj = {}
				task_obj["id"] = task
				task_obj["options"] = task_instance::DEFAULT_OPTIONS
				
				name = task_instance::NAME
				
				@task_list[name] = task_obj
			end

		end
		
		# Gets an instance of a task
		def get_task name

			if @task_list.include?(name)
				return PetitFelix::Task.const_get(@task_list[name]["id"]).new
			else
				if name.nil?
					name = "[UNDEFINED]"
				end
			
				err_no_task_found name, additional_text: "Unable to find task " + name + ":\n"
			end
		
			return nil
		end
		
		# Gets options of a task
		def get_task_options name

			if @task_list.include?(name)
				return @task_list[name]["options"]
			else
				if name.nil?
					name = "[UNDEFINED]"
				end
			
				err_no_task_found name, additional_text: "Unable to get options for Task " + name + ":\n"
			end
			
			return nil
		end
		
		# No task found error
		def err_no_task_found task, additional_text: ""
				text = "Task " + task.downcase + " not found. Make sure the variable \"task\" is set correctly in your configuration settings. Available Tasks: "
				
				@task_list.keys.each do |key|
					text += "\n  " + key
				end
				
				@error_printer.print_err text
		end
		
	end
end
