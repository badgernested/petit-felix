require "prawn"
require "prawndown-ext"

## Commands for TemplatePDFWriter

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter
			
			# List of executable commands
			
			COMMAND = {
				:print => -> (obj, args) { obj.com_print args, obj },
				:call => -> (obj, args) { obj.com_call args, obj },
				
				# PDF functions
				:text => -> (obj, args) { obj.com_text args, obj },
				:text_box => -> (obj, args) { obj.com_text_box args, obj },
				:move_down => -> (obj, args) { obj.com_move_down args, obj },
				:move_to => -> (obj, args) { obj.com_move_to args, obj },
				:move_cursor_to => -> (obj, args) { obj.com_move_cursor_to args, obj },
				:delete_page => -> (obj, args) { obj.com_delete_page args, obj },
				:start_new_page => -> (obj, args) { obj.com_start_new_page args, obj },
				:draw_text => -> (obj, args) { obj.com_draw_text args, obj },
				:font_size => -> (obj, args) { obj.com_font_size args, obj },
				:go_to_page => -> (obj, args) { obj.com_go_to_page args, obj },
				:horizontal_rule  => -> (obj, args) { obj.com_horizontal_rule args, obj },
				:image => -> (obj, args) { obj.com_image args, obj },
				:move_up => -> (obj, args) { obj.com_move_up args, obj },
				:number_pages => -> (obj, args) { obj.com_number_pages args, obj },
			}
			
			# Prawn commands
			
			def com_text args, obj
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
			
				args = args_correct_values args
			
				obj.text args[:text], args
				
				return 0
			end
			
			def com_delete_page args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
				
				obj.delete_page(args[:val])
				
				return 0
			end
			
			def com_draw_text args, obj
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
			
				validate = args_has_string :at, args
				
				if validate != 0
					return validate
				end
				
				args = args_correct_values args
			
				obj.draw_text args[:text], args
				
				return 0
			end
			
			def com_font_size args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
			
				obj.font_size args[:val]
				
				return 0
			end
			
			def com_go_to_page args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
				
				obj.go_to_page(args[:val])
				
				return 0
			end
			
			def com_horizontal_rule args, obj

				obj.horizontal_rule
				
				return 0
			end
			
			def com_image args, obj

				validate = args_has_string :file, args

				if validate != 0
					return validate
				end
				
				# if no width defined, use bounds width
				if !args.key?(:width)
					args[:width] = obj.bounds.width
				end
				
				obj.image args[:file], args
				
				return 0
			end
			
			def com_move_cursor_to args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
			
				obj.move_cursor_to args[:val]
				
				return 0
			end
			
			def com_move_down args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
			
				obj.move_down args[:val]
				
				return 0
			end
			
			def com_move_to args, obj
				validate = args_has_int :pos, args
				
				if validate != 0
					return validate
				end
				
				if !args[:pos].instance_of? Array || args[:pos].count != 2
					# position invalid
					return 11
				end
			
				obj.move_to args[:pos]
				
				return 0
			end
			
			def com_move_up args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
			
				obj.move_up args[:val]
				
				return 0
			end
			
			def com_number_pages args, obj
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
				
				args = args_correct_values args
				
				obj.number_pages args[:text], args
			
				return 0
			
			end
			
			def com_start_new_page args, obj
			
				obj.start_new_page
				
				return 0
			end
			
			def com_text_box args, obj
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
			
				args = args_correct_values args
			
				obj.text_box args[:text], args
				
				return 0
			end
			
			## Extra commands
			
			def com_print args, obj
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
			
				print args[:text]
				
				return 0
			end
			
			def com_call args, obj
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
			
				val = obj.execute_function @template_stack[-1], args[:func], obj
				
				if val[0] != 0
					return val[0]
				end
				
				return 0
			end
			
		end
	end
end
