require "prawn"
require 'fileutils'
require "prawndown-ext"
require "felix/metadata"
require "felix/error"
require "worker/pdf_writer"
require "worker/template_pdf_calls"

## Prawn PDF writer that inputs template files

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter
			
			# error count: 12
			
			ERROR_CODES = [
				"OK",
				"Malformed command list.",
				"No command defined. Use \"com\" or \"command\" to define commands.",
				"Command not found.",
				"Stack overflow.",
				"Template ID not found.",
				"Template method not found.",
				"\"{{arg}}\" argument not defined.",
				"BLANK 8",
				"BLANK 9",
				"BLANK 10",
				"Not a valid position.",
				"\"at\" (Array) argument not defined."
			]
			
			# Highest a stack is allowed to be
			MAX_STACK = 1024
			
			## Functions
			
			def init_values options, pdf
				@options = options
				@pdf = pdf
				
				# stack referencing current running commands
				@command_stack = []
				
				# stack referencing current program counter
				@counter_stack = []
				
				# stack referencing current running template
				# currently unused, will use when stitching
				# external templates together.
				@template_stack = []
				
				# Fonts
				@fonts = {}
				
				# Templates
				@template = {}
				
				# prints errors
				@error_printer = PetitFelix::Error.new
				
				# For variables of errors
				@error_param = {}
			end
			
			## Parsing template stuff
			
			# Reads template from JSON
			# Format: Array of objects where
			# each object has command and set of args
			def read_template
				if @options.key?("template")
					if File.file?(@options["template"])
						obj = JSON.parse(File.read(@options["template"]), symbolize_names: true)
					
						@template = {
							"main" => obj[:definition]
						}
						
						@fonts = {}
						
						if obj.key?(:fonts)
							@fonts = obj[:fonts]
						
						end
						
						# Runs the main function as entry point of the template
						@template_stack.push("main")
						result = execute_function "main", "main", self
						
						if result[0] != 0
							print_error result[0], result[1]
						end
					end
				end
			end
			
			def execute_function template_id, function_id, obj
			
				definition = nil

				if !@template.key?(template_id)
				
					# Fails because template ID not found.
					return [5, -1]
				else
				
					if !@template[template_id].key?(function_id.to_sym )
					
						# Fails because template function ID not found.
						return [6, -1]
					else
						definition = @template[template_id][function_id.to_sym]
					end
					
				end
			
				if definition.instance_of? Array
				
					counter = 0
					
					@counter_stack.push(counter)
					
					for index in counter ... definition.size
						
						# executes the command
						line = definition[counter]
						command = ""
						
						if line.key?(:cmd)
							command = line[:cmd].to_sym
						end
						
						if line.key?(:command)
							command = line[:command].to_sym
						end
						
						args = {
							"LINE_NUMBER" => counter
						}
						
						if line.key?(:args)
							args = line[:args]
						end
						
						if !command.empty?
							
							if COMMAND.keys.include?(command)
								@command_stack.push definition
							
								if @command_stack.count > 1024
									# Failed because of stack overflow
									return [4, counter]
								end
							
								comm = COMMAND[command].call(obj, args)

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
			
			## Error display
			
			def error_replace_string error

				@error_param.keys.each do |key|
					error = error.gsub("{{"+ key +"}}", @error_param[key])
				end
		
				error			
			end
			
			def print_error error_code, line

				if error_code > -1 && error_code < ERROR_CODES.count
					@error_printer.print_err "Error reading template. " + error_replace_string(ERROR_CODES[error_code])
				else
					@error_printer.print_err "Error reading template. General template processing error occured."
				end
				
				print "Error code: " + error_code.to_s
				
				stack_rv = @command_stack.reverse

				if line >= 0 && !stack_rv.empty?
					print "\n\nCurrent line:\n"
					print stack_rv[0][line]

					print "\n\nCurrent Stack:"
					test_arr = *(0..[19,@command_stack.count-1].min)
					test_arr.each do | i |
						command_obj = stack_rv[i]

						line_edit = command_obj[0..@counter_stack[i]+1]
					
						print "\n"
						print "Line: (" + line_edit.count.to_s + "): "
						print line_edit[-1]
					end
				end
				
				print "\n"
				
				return error_code
			end
			
			## These methods validate parameters
			
			def args_has_string arg_name, args
				if !args.key?(arg_name)
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
				end
				
				args[arg_name] = args[arg_name].to_s
				
				return 0
			end
			
			def args_has_int arg_name, args
				if !args.key?(arg_name)
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
				end
				
				args[arg_name] = args[arg_name].to_i
				
				return 0
			end
			
			def args_has_float arg_name, args
				if !args.key?(arg_name)
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
				end
				
				args[arg_name] = args[arg_name].to_f
				
				return 0
			end
			
			
			def args_has_arr arg_name, args
				if !args.key?(arg_name)
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
				end
				
				return 0
			end
			
			def args_correct_values args
				if args.key?(:align)
					args[:align] = args[:align].to_sym
				end
				
				if args.key?(:valign)
					args[:valign] = args[:valign].to_sym
				end
				
				if args.key?(:direction)
					args[:direction] = args[:direction].to_sym
				end
				
				if args.key?(:mode)
					args[:mode] = args[:mode].to_sym
				end
				
				if args.key?(:overflow)
					args[:overflow] = args[:overflow].to_sym
				end
				
				if args.key?(:rotate_around)
					args[:rotate_around] = args[:rotate_around].to_sym
				end
				
				if args.key?(:position)

					if ["left","center","right"].include? args[:position]
						args[:position] = args[:position].to_sym
					else
						args[:position] = args[:position].to_i
					end

				end
				
				args
				
			end
			
		end
	end
end
