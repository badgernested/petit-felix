## font handling stuff for TemplatePDFWriter

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter

			# Adds a font to the pdf document
			def add_font font, font_name

				if font.key?(:normal)
				
					if font.key?(:italic)
					
						font[:italic] = font[:normal]
						
					end
					
					if font.key?(:bold)
					
						font[:bold] = font[:normal]
						
					end
					
					if font.key?(:bold_italic)
					
						font[:bold_italic] = font[:normal]
						
					end
					
					font.keys.each do |key|
					
						font[key] = replace_variable font[key]
						
					end
				
					font_families.update(font_name => font)
					
				end
						
			end
			
			def add_fonts
			
				font_families.clear
				
				fonts = Marshal.load(Marshal.dump(@fonts))
			
				fonts.keys.each do |font|
				
					add_font fonts[font], font.to_s
					
				end
				
			end
			
		end
	end
end
