require "prawn"
require 'fileutils'
require "prawndown-ext"
require "felix/metadata"
require "felix/error"
require "worker/pdf_writer"
require "worker/templater/methods"
require "worker/templater/error"
require "worker/templater/validation"
require "worker/templater/font"
require "eqn"

## Prawn PDF writer that inputs template files

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter
			
			# Highest a stack is allowed to be
			MAX_STACK = 1024
			
			## Functions
			
			def init_values options, pdf
			
				@variables = {}
			
				@options = Marshal.load(Marshal.dump(options))
				
				# Options to use for method calls and stuff
				# Updated every time a template is loaded
				@metaoptions = {}
				@pdf = pdf
				
				# stack referencing current running commands
				@command_stack = []
				
				# stack referencing current program counter
				@counter_stack = []
				
				# stack referencing current running template
				# currently unused, will use when stitching
				# external templates together.
				@template_stack = []
				
				# Templates
				@template = {}
				
				# prints errors
				@error_printer = PetitFelix::Error.new
				
				# For variables of errors
				@error_param = {}
				
				set_variables
			end
			
			def set_variables
			
				@metaoptions.keys.each do |key|
				
					@variables[key] = @metaoptions[key]
					
				end
				
				if @variables.key? :markdown_metadata
				
					@variables[:markdown_metadata].keys.each do |meta|
					
						@variables[meta] = @variables[:markdown_metadata][meta]
						
					end
					
				end
				
				## add additional functional stuff
				@variables["cursor"] = @pdf.cursor
				@variables["bounds_height"] = @pdf.bounds.height
				@variables["bounds_width"] = @pdf.bounds.width
				@variables["pages"] = @pdf.page_count
				
				# the currently loaded markdown file
				@variables["loaded_markdown"] = {}

			end
			
			def replace_variables args
			
				args.keys.each do |arg|
				
					if args[arg].instance_of? String
					
						args[arg] = replace_variable args[arg]
						
					end
				end
				
				args
				
			end
			
			def replace_variable string
			
				@variables.keys.each do |key|
					string = string.gsub("${#{key}}", @variables[key].to_s)
				end
				
				string
			end
			
			## Parsing template stuff
			
			# Reads template from JSON
			# Format: Array of objects where
			# each object has command and set of args
			def read_template
			
				if @options.key? "template"
				
					if File.file? @options["template"]
					
						obj = JSON.parse(File.read(@options["template"]), symbolize_names: true)
					
						default_options = obj[:default_variables].transform_keys!(&:to_s)
						
						if default_options.nil?
							default_options = {}
						end
						
						@fonts = {}
						
						@metaoptions = default_options.merge @options
						
						set_variables
						
						if obj.key? :fonts
						
							@fonts = obj[:fonts]
							
						end
						
						add_fonts
						
						@template = {
							"main" => obj[:definition]
						}
						
						# Runs the main function as entry point of the template
						@template_stack.push "main"
						result = execute_function "main", "main", self
						
						if result[0] != 0
						
							print_error result[0], result[1]
						end
						
					else
					
						@error_param["arg"] = @options["template"].to_s
						print_error 15, -1
						
					end
					
				else
				
					print_error 16, -1
					
				end
			end
			
			def execute_function template_id, function_id, obj
			
				definition = nil

				if !@template.key? template_id
				
					@error_param["arg"] = template_id.to_s
					# Fails because template ID not found.
					return [5, -1]
					
				else
				
					if !@template[template_id].key? function_id.to_sym
					
						@error_param["arg"] = function_id.to_s
						# Fails because template function ID not found.
						return [6, -1]
						
					else
					
						definition = Marshal.load(Marshal.dump(@template[template_id][function_id.to_sym]))
					
					end
					
				end
			
				if definition.instance_of? Array

					counter = 0
					
					@counter_stack.push counter
					
					for index in counter ... definition.size

						# executes the command
						line = definition[counter]
						
						set_variables
						
						command = ""
						
						if line.key? :cmd
						
							command = line[:cmd].to_sym
							
						end
						
						if line.key? :command
						
							command = line[:command].to_sym
							
						end
						
						args = {
							"LINE_NUMBER" => counter
						}
						
						if line.key? :args
						
							args = line[:args]
							
						end
						
						begin
						
							args = replace_variables(args)
							
						rescue => error
						
							print "\n"
							print error
							print "\n"
							print "Error rendering variables!\n"
							
						end
						
						if !command.empty?
							
							if COMMAND.keys.include? command
							
								@command_stack.push definition
							
								if @command_stack.count > 1024
									# Failed because of stack overflow
									return [4, counter]
									
								end
								
								comm = COMMAND[command].call obj, args

								@counter_stack[-1] = counter
								counter += 1

								# something about command execution failed
								if comm != 0
								
									return [comm, counter]
									
								end

								@command_stack.pop
							else
								# failed because command not found
								return [3, counter]
								
							end

						else
							# failed because no command defined
							return [2, -1]
						
						end
					end
					
					@counter_stack.pop()
					
					# Returns 0 if successful
					return [0, counter]
					
				end

				# Failed because malformed command list
				return [1, -1]
				
			end
			
		end
	end
end
