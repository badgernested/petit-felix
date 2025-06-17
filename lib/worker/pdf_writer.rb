require "prawn"
require 'fileutils'
require "prawndown-ext"
require "worker/pdf_writer/column_box"
require "worker/pdf_writer/bounding_box"

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
			
			
    def start_new_page(options = {})
      last_page = state.page
      if last_page
        last_page_size = last_page.size
        last_page_layout = last_page.layout
        last_page_margins = last_page.margins.dup
      end

      page_options = {
        size: options[:size] || last_page_size,
        layout: options[:layout] || last_page_layout,
        margins: last_page_margins,
      }
      if last_page
        if last_page.graphic_state
          new_graphic_state = last_page.graphic_state.dup
        end

        # erase the color space so that it gets reset on new page for fussy
        # pdf-readers
        new_graphic_state&.color_space = {}

        page_options[:graphic_state] = new_graphic_state
      end

      state.page = PDF::Core::Page.new(self, page_options)

      apply_margin_options(options)
      generate_margin_box

      # Reset the bounding box if the new page has different size or layout
      if last_page && (last_page.size != state.page.size ||
                       last_page.layout != state.page.layout)
        @bounding_box = @margin_box
      end

      use_graphic_settings

      unless options[:orphan]
        state.insert_page(state.page, @page_number)
        @page_number += 1

        if @background
          canvas do
            image(@background, scale: @background_scale, at: bounds.top_left)
          end
        end
        @y = @bounding_box.absolute_top

        float do
          state.on_page_create_action(self)
        end
      end
      
    end
		
		end
	end
end
