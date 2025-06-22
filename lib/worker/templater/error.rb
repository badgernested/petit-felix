## Error handling stuff for TemplatePDFWriter

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter
			
			# error count: 16
			
			ERROR_CODES = [
				"OK",
				"Malformed command list.",
				"No command defined. Use \"com\" or \"command\" to define commands.",
				"Command \"{{arg}}\" not found.",
				"Stack overflow.",
				"Template ID \"{{arg}}\" not found.",
				"Template method \"{{arg}}\" not found.",
				"\"{{arg}}\" argument not defined.",
				"Expression \"{{arg}}\" does not result in boolean result.",
				"Expression \"{{arg}}\" cannot be evaluated.",
				"File \"{{arg}}\" not found.",
				"Not a valid position.",
				"\"at\" (Array) argument not defined.",
				"\"{{arg}}\" is not an array.",
				"Image \"{{arg}}\" not found.",
				"Template file \"{{arg}}\" not found.",
				"\"template\" option not defined. No template file can be loaded."
			]
			
			## Error display
			
			def error_replace_string error

				@error_param.keys.each do |key|
				
					error = error.gsub "{{#{key}}}", @error_param[key]
					
				end
		
				error			
			end
			
			def print_error error_code, line

				if error_code > -1 && error_code < ERROR_CODES.count
				
					@error_printer.print_err "Error reading template. #{error_replace_string( ERROR_CODES[error_code])}"
					
				else
				
					@error_printer.print_err "Error reading template. General template processing error occured."
					
				end
				
				print "Error code: #{error_code}"
				
				print "\n\n"
				print "Processing markdown file: #{@metaoptions["filename"]}"
				print "\n\n"
				
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
						print "Line: #{line_edit.count}: "
						print line_edit[-1]
						
					end
				end
				
				print "\n"
				
				return error_code
			end
			
		end
	end
end
