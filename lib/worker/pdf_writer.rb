require "prawn"
require 'fileutils'
require "prawndown-ext"

## Prawn PDF writer that outputs template files

module PetitFelix
	module Worker

		class	DefaultPDFWriter < Prawn::Document
		
			# Initializes fonts
			def initialize_font
			
				add_font "default"

			end
		
			# Adds a font to the pdf document
			def add_font (type,
									default_font: "default")

					if @options.key?(type + "_font_normal")
					
						font_normal = type + "_font_normal"
						font_italic = type + "_font_normal"
						font_bold = type + "_font_normal"
						font_bold_italic = type + "_font_normal"
						
						if @options.key?(type + "_font_italic")
							font_italic = type + "_font_italic"
						end
						if @options.key?(type + "_font_bold")
							font_bold = type + "_font_bold"
						end
						if @options.key?(type + "_font_bold_italic")
							font_bold_italic = type + "_font_bold_italic"
						end
					
						font_families.update(type => {
							:normal => @options[font_normal],
							:italic => @options[font_italic],
							:bold => @options[font_bold],
							:bold_italic => @options[font_bold_italic]
						})
						
					else
						if font_families.key?(default_font)
							font_families.update(type => {
								:normal => font_families[default_font][:normal],
								:italic => font_families[default_font][:italic],
								:bold => font_families[default_font][:bold],
								:bold_italic => font_families[default_font][:bold_italic]
							})
							
						else
							font_families.update(type => {
								:normal => @options["font_normal"],
								:italic => @options["font_italic"],
								:bold => @options["font_bold"],
								:bold_italic => @options["font_bold_italic"]
							})
						end
						
					end
			end
		
			def set_options metaoptions
				@options = metaoptions
			end
		
			def output
				FileUtils.mkdir_p @options["output_dir"]
				render_file(@options["output_dir"] + "/" + @options["title"].gsub(/[^\w\s]/, '').tr(" ", "_") + '.pdf')
			end
		
		end
	end
end
