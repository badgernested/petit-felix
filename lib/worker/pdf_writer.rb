require "prawn"
require 'fileutils'
require "prawndown-ext"
require "felix/file"
require "worker/pdf_writer/column_box"
require "worker/pdf_writer/bounding_box"
require "felix/metadata"

## Prawn PDF writer that outputs template files

module PetitFelix
	module Worker

		class	DefaultPDFWriter < Prawn::Document
		
			def right_to_left
				return @right_to_left
			end
			
			def set_right_to_left val
				@right_to_left = val
			end
		
			def alternates_pages
				return @alternates_pages
			end
			
			def set_alternate_pages val
				@alternates_pages = val
			end
		
			# Initializes fonts
			def initialize_font
			
				add_font "default"

			end
		
			# Adds a font to the pdf document
			def add_font (type,
									default_font: "default")

					if @options.key? "#{type}_font_normal"
					
						font_normal = "#{type}_font_normal"
						font_italic = "#{type}_font_normal"
						font_bold = "#{type}_font_normal"
						font_bold_italic = "#{type}_font_normal"
						
						if @options.key? "#{type}_font_italic"
						
							font_italic = "#{type}_font_italic"
							
						end
						
						if @options.key? "#{type}_font_bold"
						
							font_bold = "#{type}_font_bold"
							
						end
						
						if @options.key? "#{type}_font_bold_italic"
						
							font_bold_italic = "#{type}_font_bold_italic"
							
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
				@alternates_pages = false
				@right_to_left = false
				
				@options = metaoptions
				
				md = PetitFelix::Metadata.new
				
				metadata = md.get_metadata(md.split(File.read metaoptions["filename"])[0])
				
				@options = @options.merge(metadata)
				
			end
		
			def output
				
				fileedit = PetitFelix::FileManager.new
				
				file_output = fileedit.file_array_from_string(@options["output_dir"]) + [@options["output_file"]]

				file = File.join(file_output)

				FileUtils.mkdir_p File.dirname(file)
				render_file(file)
				
			end
			
			# Copies the contents of a page.
			def copy_page index=@page_number-1
			
				return false if index.abs > (state.pages.count - 1)
			
				# deep copies the page data
				@page_data = copy_page_data index
				
			end
			
			# Returns the page data copied
			def copy_page_data index
				return false if index.abs > (state.pages.count - 1)
			
				# deep copies the page data
				return Marshal.load(Marshal.dump(state.store.pages.data[:Kids][index]))
			end
			
			# Pastes (overwrites) the content of a page.
			def paste_page index=@page_number-1

				return false if index.abs > (state.pages.count - 1)
			
				if !@page_data.nil?
				
					state.store.pages.data[:Kids][index] = @page_data

					# deep copies the page data so its not referencing the same object constantly
					@page_data = Marshal.load(Marshal.dump(@page_data))
					
				end
				
			end
			
			# Clears copied page data.
			def clear_copied_page
			
				@page_data = nil
				
			end
			
			# Reorganizes the pages in the given order.
			
			def reorder_pages pages
			
				if pages.count != state.pages.count
				
					return false
					
				end
				
				initial_content = []
				
				state.store.pages.data[:Kids].each_with_index {
					|item,index| 
					initial_content.append(state.store.pages.data[:Kids][index])
				}
				
				index = 0
				
				while index < initial_content.count
				
					return false if pages[index].abs > (state.pages.count - 1)
				
					state.store.pages.data[:Kids][index] = initial_content[pages[index]]
					index +=1
					
				end
			
			end
			
			# Orders the pages properly so they can be printed 2 on a page for stapling
			def reorder_pages_for_2_page
			
				pages = []
				pairs = []
				
				# Test if the pages line up to mod 4 for double print
				# if not, fix it

				modval = state.pages.count % 4
				
				if modval > 0

					modval = 4 - modval

					go_to_page(2)
					
					start_new_page
					
					modval -= 1
					
					go_to_page(-3)
					
					(modval).times do
						start_new_page
					end
					
				end
				
				go_to_page(state.pages.count)
				
				# Now that its even do the algorithm
				center = (state.pages.count / 2) - 1 
				center_other = center + 1
				
				while center >= 0
				
					pairs.unshift [center, center_other]
					
					center -= 1
					center_other += 1
					
				end
				
				counter = 0
				
				pairs.each do |item|
				
					counter += 1
					
					pages.append item[0]
					pages.append item[1]
					
					if !@right_to_left && (counter % 4 == 1 || counter % 4 == 3) 
						pages[-2] = item[1]
						pages[-1] = item[0]

					end
				
				end
			
				reorder_pages pages
			
			end
		
		end
	end
end
