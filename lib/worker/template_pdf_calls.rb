require "prawn"
require "prawndown-ext"
require "eqn"
require "felix/metadata"

## Commands for TemplatePDFWriter

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter
			
			# List of executable commands
			
			COMMAND = {
				:print => -> (obj, args) { obj.com_print args, obj },
				:call => -> (obj, args) { obj.com_call args, obj },
				:if => -> (obj, args) { obj.com_if args, obj },
				:elif => -> (obj, args) { obj.com_elif args, obj },
				:each => -> (obj, args) { obj.com_each args, obj },
				:times => -> (obj, args) { obj.com_times args, obj },
				:set => -> (obj, args) { obj.com_set args, obj },
				
				# Loads Markdown file data into @variables
				:read_markdown => -> (obj, args) { obj.com_read_markdown args, obj },
				:clear_markdown => -> (obj, args) { obj.com_clear_markdown args, obj },
				
				# PDF functions
				:text => -> (obj, args) { obj.com_text args, obj },
				:markdown => -> (obj, args) { obj.com_markdown args, obj },
				:text_box => -> (obj, args) { obj.com_text_box args, obj },
				:move_down => -> (obj, args) { obj.com_move_down args, obj },
				:move_to => -> (obj, args) { obj.com_move_to args, obj },
				:move_cursor_to => -> (obj, args) { obj.com_move_cursor_to args, obj },
				:delete_page => -> (obj, args) { obj.com_delete_page args, obj },
				:start_new_page => -> (obj, args) { obj.com_start_new_page args, obj },
				:draw_text => -> (obj, args) { obj.com_draw_text args, obj },
				:font => -> (obj, args) { obj.com_font args, obj },
				:font_size => -> (obj, args) { obj.com_font_size args, obj },
				:go_to_page => -> (obj, args) { obj.com_go_to_page args, obj },
				:horizontal_rule  => -> (obj, args) { obj.com_horizontal_rule args, obj },
				:image => -> (obj, args) { obj.com_image args, obj },
				:move_up => -> (obj, args) { obj.com_move_up args, obj },
				:number_pages => -> (obj, args) { obj.com_number_pages args, obj },
				:bounding_box => -> (obj, args) { obj.com_bounding_box args, obj },
				:column_box => -> (obj, args) { obj.com_column_box args, obj },
				:indent => -> (obj, args) { obj.com_indent args, obj },
				:pad => -> (obj, args) { obj.com_pad args, obj },
				:pad_bottom => -> (obj, args) { obj.com_pad_bottom args, obj },
				:pad_top => -> (obj, args) { obj.com_pad_top args, obj },
				:rotate => -> (obj, args) { obj.com_rotate args, obj },
				:scale => -> (obj, args) { obj.com_scale args, obj },
				:span => -> (obj, args) { obj.com_span args, obj },
				:translate => -> (obj, args) { obj.com_translate args, obj },
				:transparent => -> (obj, args) { obj.com_transparent args, obj },
			}
			
			# Prawn commands
			
			def com_bounding_box args, obj

				validate = args_has_arr :at, args, :int
				
				if validate != 0
					return validate
				end
				
				validate = args_has_int :width, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
				
				args_has_int :height, args
				
				args_has_arr :margin, args, :hash, { :second_type => :int }
			
				args[:base_margins] = args[:margin]
			
				args = args_correct_values args
				
				# Calls the function at "func"
				obj.bounding_box args[:at], args do
					
					val = obj.execute_function @template_stack[-1], args[:func], obj
			
					if val[0] != 0
						return val[0]
					end
						
				end
				
				return 0
			end
			
			def com_column_box args, obj
				validate = args_has_arr :at, args, :int
				
				if validate != 0
					return validate
				end
				
				validate = args_has_int :width, args
				
				if validate != 0
					return validate
				end
				
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
				
				args_has_int :height, args
				args_has_int :columns, args
				args_has_float :spacer, args
				
				args_has_arr :margin, args, :hash, { :second_type => :int }
				
				args[:base_margins] = args[:margin]
				
				# Calls the function at "func"
				obj.column_box args[:at], args do
					
					val = obj.execute_function @template_stack[-1], args[:func], obj
					
					if val[0] != 0
						return val[0]
					end
						
				end
				
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
			
				validate = args_has_arr :at, args, :int
				
				if validate != 0
					return validate
				end
				
				args_has_float :size, args
				args_has_rotate :size, args
				
				args = args_correct_values args
			
				obj.draw_text args[:text], args
				
				return 0
			end
			
			def com_font args, obj
				validate = args_has_string :val, args
				
				if validate != 0
					return validate
				end
			
				validate = args_has_string :style, args
				
				args = args_correct_values args
			
				obj.font args[:val]
				
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
				if !args.key?(:width) && !args.key?(:height)
					args[:width] = obj.bounds.width
				end
				
				args_has_arr :at, args, :float
				args_has_float :height, args
				args_has_float :width, args
				args_has_float :scale, args
				
				args = args_correct_values args

				if File.file?(args[:file])
				
					obj.image args[:file], args
				else
				
					var = PetitFelix::Metadata.new.get_image_location(@metaoptions["image_dir"], args[:file])
				
					if File.file?(var)
					
						obj.image var, args
					
					else
				
						@error_param["arg"] = args[:file].strip
						return 14
					
					end
					
				end

				
				return 0
			end
			
			def com_indent args, obj
				left = 0
				
				if args.key?(:left)
					right = args[:left].to_i
				end
				
				right = 0
				
				if args.key?(:right)
					right = args[:right].to_i
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
			
				# Calls the function at "func"
				obj.indent left, right do
					
					val = obj.execute_function @template_stack[-1], args[:func], obj
					
					if val[0] != 0
						return val[0]
					end
						
				end
				
				return 0
			end
			
			# Later - change this to reading a file's input.
			def com_markdown args, obj
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
			
				args = args_correct_values args
			
				set_variables
				
				optio = Marshal.load(Marshal.dump(@variables))

				obj.markdown args[:text], options: optio
				
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
				validate = args_has_arr :pos, args, :float
				
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
				
				args_has_int :width, args
				args_has_arr :at, args, :int
				args_has_arr :odd_at, args, :int
				args_has_arr :even_at, args, :int
				args_has_int :page_finish, args

				page_mode = :default
				
				if args.key?(:page_mode)
					page_mode = args[:page_mode].to_sym
				end
				
				if page_mode == :alternate
				
					if !args.key?(:odd_start_count_at) && !args[:start_count_at].nil?
						args[:odd_start_count_at] = args[:start_count_at]
					end
					
					if !args.key?(:even_start_count_at) && !args[:start_count_at].nil?
						args[:even_start_count_at] = args[:start_count_at]
					end
					
					args_has_int :start_count_at, args
					args_has_int :odd_start_count_at, args
					args_has_int :even_start_count_at, args
					
					if !args.key?(:page_finish)
						args[:page_finish] = -1
					end
						
					odd_array = {
						:start_count_at => args[:odd_start_count_at],
						:at => args[:odd_at],
						:align => args[:odd_align]
					}
					
					even_array = {
						:start_count_at => args[:even_start_count_at],
						:at => args[:even_at],
						:align => args[:even_align]
					}
				
					odd_options = odd_array.merge(args)
				
					even_options = even_array.merge(args)
					
					args_has_int :page_start, args
					args_has_int :page_finish, args
					
					odd_options[:start_count_at] += 1
					
					if !args.key?(:page_start)
						@variables["paginator_start"] = @metaoptions["paginator_start"]
					else
						@variables["paginator_start"] = args[:page_start]
					end
					
					@variables["paginator_end"] = args[:page_finish]
				
					if @metaoptions["paginator_switch"]
						odd_options[:page_filter] = ->(pg) { pg > @variables["paginator_start"] && (pg < @variables["paginator_end"] || @variables["paginator_end"] <= -1) && pg % 2 == 1 }
						even_options[:page_filter] = ->(pg) { pg > @variables["paginator_start"] && (pg < @variables["paginator_end"] || @variables["paginator_end"] <= -1) && pg % 2 == 0 }
						
					else
						even_options[:page_filter] = ->(pg) { pg > @variables["paginator_start"] && (pg < @variables["paginator_end"] || @variables["paginator_end"] <= -1) && pg % 2 == 1 }
						odd_options[:page_filter] = ->(pg) { pg > @variables["paginator_start"] && (pg < @variables["paginator_end"] || @variables["paginator_end"] <= -1) && pg % 2 == 0 }
					
					end

					string = replace_variable args[:text]
					
					number_pages string, odd_options
					number_pages string, even_options
				
				else
				
					obj.number_pages args[:text], args
					
				end
			
				return 0
			
			end
			
			def com_pad args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
			
				# Calls the function at "func"
				obj.pad args[:val] do
					
					val = obj.execute_function @template_stack[-1], args[:func], obj
					
					if val[0] != 0
						return val[0]
					end
						
				end
				
				return 0
			end
			
			def com_pad_bottom args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
			
				# Calls the function at "func"
				obj.pad_bottom args[:val] do
					
					val = obj.execute_function @template_stack[-1], args[:func], obj
					
					if val[0] != 0
						return val[0]
					end
						
				end
				
				return 0
			end
			
			
			def com_pad_top args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
			
				# Calls the function at "func"
				obj.pad_top args[:val] do
					
					val = obj.execute_function @template_stack[-1], args[:func], obj
					
					if val[0] != 0
						return val[0]
					end
						
				end
				
				return 0
			end
			
			def com_rotate args, obj
				validate = args_has_float :angle, args
				
				if validate != 0
					return validate
				end
				
				if args.key?(:func)
				
					validate = args_has_arr :origin, args, :float
					
					if validate != 0
						return validate
					end
				
					obj.rotate(args[:angle], args) do
						val = obj.execute_function @template_stack[-1], args[:func], obj
											
											if val[0] != 0
												return val[0]
											end
					end
				
				else
				
					obj.rotate args[:angle]
				
				end
				
				return 0
			end
			
			def com_scale args, obj
				validate = args_has_float :factor, args
				
				if validate != 0
					return validate
				end
				
				if args.key?(:func)
				
					validate = args_has_arr :origin, args, :float
					
					if validate != 0
						return validate
					end
				
					obj.scale(args[:factor], args) do
						val = obj.execute_function @template_stack[-1], args[:func], obj
											
						if val[0] != 0
							return val[0]
						end
					end
				
				else
				
					obj.scale args[:factor]
				
				end
				
				return 0
			end
			
			def com_span args, obj
				args = args_correct_values args
			
				validate = args_has_float :width, args
				
				if validate != 0
					return validate
				end
				
				args_has_string :position, args
				
				if args.key?(:func)
				
					obj.span(args[:width], args) do
						val = obj.execute_function @template_stack[-1], args[:func], obj
						
						if val[0] != 0
							return val[0]
						end
						
					end
					
				end
				
				return 0
			end
			
			def com_text args, obj
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
			
				args_has_int :size, args
				args_has_float :character_spacing, args
				args_has_float :leading, args
				args_has_string :direction, args
				args_has_string :align, args
				args_has_string :valign, args
				args_has_string :mode, args
			
				args = args_correct_values args
			
				obj.text args[:text], args
				
				return 0
			end
			
			def com_text_box args, obj
			
				validate = args_has_string :text, args
				
				if validate != 0
					return validate
				end
				
				args_has_int :size, args
				args_has_float :width, args
				args_has_float :height, args
				args_has_string :direction, args
				args_has_string :align, args
				args_has_string :valign, args
				args_has_float :rotate, args
				args_has_string :rotate_around, args
				args_has_float :character_spacing, args
				args_has_float :leading, args
				args_has_string :overflow, args
				args_has_int :min_font_size, args
			
				args = args_correct_values args

				obj.text_box args[:text], args
				
				return 0
			end
			
			def com_translate args, obj
				validate = args_has_int :x, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_int :y, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
				
				obj.translate(args[:x], args[:y]) do
					val = obj.execute_function @template_stack[-1], args[:func], obj
					
					if val[0] != 0
						return val[0]
					end
					
				end
				
				return 0
			end
			
			def com_start_new_page args, obj
			
				obj.start_new_page
				
				return 0
			end
			
			def com_transparent args, obj
				validate = args_has_float :opacity, args
				
				if validate != 0
					return validate
				end
				
				stroke_opacity = args[:opacity]
				
				if args.key?(:stroke_opacity)
					stroke_opacity = args[:stroke_opacity].to_f
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
				
				obj.transparent(args[:opacity], stroke_opacity) do
					val = obj.execute_function @template_stack[-1], args[:func], obj
					
					if val[0] != 0
						return val[0]
					end
					
				end
				
				return 0
			end
			
			def com_start_new_page args, obj
			
				obj.start_new_page
				
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
			
			def com_if args, obj
				validate = args_has_string :exp, args
				
				if validate != 0
					return validate
				end
			
				result = false
			
				if ["true","false"].include? args[:exp].strip
					if args[:exp]
						result = true
					else
						result = false
					end
				else
				
					begin
						result = Eqn::Calculator.calc(args[:exp].strip)
					rescue
						# expression cannot be evaluated
						return 9
					end
				
				end
				
				if [true, false].include? result
					
					validate = args_has_string :func, args
					
					if validate != 0
						return validate
					end
					
					if result
					
						val = obj.execute_function @template_stack[-1], args[:func], obj
						
						if val[0] != 0
							return val[0]
						end
						
					end
				
					return 0
					
				end
				
				
				# expression does not return boolean
				@error_param["arg"] = args[:exp].strip
				return 8

			end
			
			def com_elif args, obj
				validate = args_has_string :exp, args
				
				if validate != 0
					return validate
				end
			
				result = false
			
				if ["true","false"].include? args[:exp].strip
					if args[:exp]
						result = true
					else
						result = false
					end
				else
				
					begin
						result = Eqn::Calculator.calc(args[:exp].strip)
					rescue
						# expression cannot be evaluated
						@error_param["arg"] = args[:exp].strip
						return 9
					end
				
				end
				
				if [true, false].include? result
					
					validate = args_has_string :func, args
					
					if validate != 0
						return validate
					end
					
					validate = args_has_string :func_else, args
					
					if validate != 0
						return validate
					end
					
					if result
					
						val = obj.execute_function @template_stack[-1], args[:func], obj
						
						if val[0] != 0
							return val[0]
						end
						
					else
					
						val = obj.execute_function @template_stack[-1], args[:func_else], obj
						
						if val[0] != 0
							return val[0]
						end
						
					end
					
					return 0
					
				end
				
				
				# expression does not return boolean
				@error_param["arg"] = args[:exp].strip
				return 8

			end
			
			
			# this reads markdown and also adds the metadata
			def com_read_markdown args, obj
				# clears the current markdown file
				com_clear_markdown args, obj
				
				validate = args_has_string :file, args
				
				if validate != 0
					return validate
				end
				
				if File.file? args[:file]
					
					markdown = {}
					
					page = File.read(args[:file])
					
					# splits the page into parts for metadata and content
					
					# Felix metadata handler
					metadata_helper = PetitFelix::Metadata.new
						
					page_data = metadata_helper.split page
							
					@variables[:markdown_metadata] = metadata_helper.get_metadata page_data[0]
						
					@variables[:markdown_content] = page_data[1].strip

					set_variables
					add_fonts
	
					return 0
					
				else
					# File not found
					@error_param["arg"] = args[:file].strip
					return 10
				end
				
			end
			
			# This clears the markdown file from memory
			def com_clear_markdown args, obj
				@variables.delete(:markdown_metadata)
				@variables.delete(:markdown_content)
				
				return 0
			end
			
			
			# Reads from an array of objects and performs a function on all of them
			# populates @variables[:each] with the each value
			def com_each args, obj
				validate = args_has_string :data, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
			
				arr = PetitFelix::Metadata.new.parse_property args[:data]
				
				if arr.instance_of? Array
					
					arr.each do |arr_obj|
						@variables[:each] = arr_obj
						
						val = obj.execute_function @template_stack[-1], args[:func], obj
	
						if val[0] != 0
							return val[0]
						end
						
					end
					
					@variables.delete(:each)
					
				else
					@error_param["arg"] = args[:data].strip
					return 13
				end
				
				return 0
			
			end
			
			# Does an operation a number of times
			# populates @variables[:each] with the each value
			def com_times args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :func, args
				
				if validate != 0
					return validate
				end
			
				val = args[:val].to_i
				
				if val.is_a? Integer
					
					val.times do
						valz = obj.execute_function @template_stack[-1], args[:func], obj
						
						if valz[0] != 0
							return valz[0]
						end
						
					end
					
				else
					@error_param["arg"] = args[:val].strip
					return 13
				end
			
				return 0
			
			end
			
			## sets a variable to a value
			def com_set args, obj
				validate = args_has_int :val, args
				
				if validate != 0
					return validate
				end
				
				validate = args_has_string :var, args
				
				if validate != 0
					return validate
				end
			
				@variables[args[:var]] = args[:val]

				return 0
			end
			
		end
	end
end
