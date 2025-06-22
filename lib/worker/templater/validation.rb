## validation stuff for TemplatePDFWriter

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter
			
			SYMBOLIZE = [
				:align,
				:odd_align,
				:even_align,
				:valign,
				:odd_valign,
				:even_valign,
				:direction,
				:mode,
				:style,
				:overflow,
				:vposition,
				:rotate_around
			]
			
			## variable validation methods
			
			def args_has_string arg_name, args
			
				if !args.key? arg_name
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
				end
				
				args[arg_name] = replace_variable args[arg_name].to_s
				
				return 0
				
			end
			
			def args_has_file arg_name, args
			
				if !args.key? arg_name
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
				end
				
				file = replace_variable args[arg_name].to_s
				

				
				args[arg_name] = file
				
				return 0
				
			end
			
			def args_has_int arg_name, args
			
				if args.nil? || !args.key?(arg_name) || args[arg_name].nil?
				
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
					
				end

				if args[arg_name].instance_of? String
				
					begin
					
						args[arg_name] = Eqn::Calculator.calc(replace_variable args[arg_name]).to_i
					rescue
					
						@error_param["arg"] = replace_variable args[arg_name].to_s
						return 9
					end
				end
				
				return 0
			end
			
			def args_has_float arg_name, args

				if args.nil? || !args.key?(arg_name) || args[arg_name].nil?
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
					
				end
				
				begin
				
					args[arg_name] = Eqn::Calculator.calc(replace_variable args[arg_name]).to_f
				
				rescue
				
					@error_param["arg"] = replace_variable args[arg_name].to_s
					return 9
					
				end
				
				return 0
				
			end
			
			def args_has_arr arg_name, args, type, options = {}
			
				if !args.key? arg_name
					# text not defined
					@error_param["arg"] = arg_name.to_s
					return 7
					
				end
				
				if args[arg_name].instance_of? String
				
					begin
					
						set_variables

						test = replace_variable args[arg_name]
						
						args[arg_name] = JSON.parse(test)

					rescue => error
					
						print "\nError parsing array: #{args[arg_name]}\n"
						print error
					
					end
					
				end
				
				if args[arg_name].instance_of? Array	
				
						if type == :float
						
							args[arg_name].map! {|item| Eqn::Calculator.calc(replace_variable item.to_s).to_f }
						elsif type == :int
						
							args[arg_name].map! {|item| Eqn::Calculator.calc(replace_variable item.to_s).to_i }
						elsif type == :hash
						
							args[arg_name].map! {|item| args_correct_hash item, options[:second_type] }
						else
						
							args[arg_name].map! {|item| replace_variable item.to_s }
						end
						
				end
				
				return 0
				
			end
			
			def args_correct_hash hash, type
			
				hash.transform_keys!(&:to_sym)
			
				hash.keys.each do |key|

					if type == :int
					
						begin
						
							hash[key] = Eqn::Calculator.calc(replace_variable hash[key].to_s).to_i
							
						rescue
						
							@error_param["arg"] = replace_variable hash[key]
							return 9
							
						end
						
					elsif type == :float
					
						begin
						
							hash[key] = Eqn::Calculator.calc(replace_variable hash[key].to_s).to_f
						rescue
						
							@error_param["arg"] = replace_variable hash[key]
							return 9
							
						end
						
					else
					
						hash[key] = replace_variable hash[key].to_s
					end
					
				end
				
				hash
				
			end
			
			def args_correct_values args
			
				args_has_int :width, args
				args_has_int :height, args

				SYMBOLIZE.each do |symbol|
				
					if args.key? symbol
					
						args[symbol] = args[symbol].to_sym
						
					end
				end
				
				if args.key? :position

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
