require "task/default_task"
require "worker/basic_pdf_writer"

module PetitFelix

	module Task
	
		class BasicPDFTask < PetitFelix::Task::DefaultTask
		
			NAME = "basic_pdf"

			## Default options of the application
			DEFAULT_OPTIONS = {
					"columns" => 1,
					"default_font_size" => 12,
					"header1_size" => 32,
					"header2_size" => 28,
					"header3_size" => 20,
					"header4_size" => 18,
					"header5_size" => 16,
					"header6_size" => 14,
					"quote_size" => 14,
					"margin" =>  40,
					"font_normal" => "./assets/font/Unageo-Regular.ttf",
					"font_italic"=> "./assets/font/Unageo-Regular-Italic.ttf",
					"font_bold"=> "./assets/font/Unageo-ExtraBold.ttf",
					"font_bold_italic" => "./assets/font/Unageo-ExtraBold-Italic.ttf",
					"paginator_start_count" => 1,
					"paginator_start" => 1,
					"paginator" => true,
					"paginator_alternate" => false,
					"back_text" => "",
					"back_text_margin" => 0,
					"back_text_size" => 14,
					"front_title_size"=> 32,
					"front_author_size" => 18,
					"front_date_size" => 14,
					"back_publisher" => "",
					"back_publisher_size" => 14,
					"front_publisher" => "",
					"front_publisher_size" => 14,
					"paginator_size" => 12,
					"back_author" => "",
					"back_author_size" => 16,
			}

			def render_zine
				
				# Only continue if metadata has a title
					
				if @metadata.key?("title")
								
					# Parameters
						
					page_layout = :portrait
					print_scaling = :none
					
					if @metaoptions.key?("page_layout")
						page_layout = @metaoptions["page_layout"]
						
						if page_layout.is_a? String
							if page_layout.include?("portrait")
								page_layout = :portrait
							else 
								if page_layout.include?("landscape")
								page_layout = :landscape
								end
							end
						end
					end

					# Generates PDF
						
					pdf = PetitFelix::Worker::BasicPDFWriter.new(
						page_layout: page_layout,
						print_scaling: print_scaling)


					pdf.set_options @metaoptions

					# Adds extra fonts
					
					pdf.initialize_font
					
					# Title page generation

					pdf.title_page

					# Does the main content
					pdf.main_block @content
					
					# Does page numbering
					pdf.page_numbering
					
					pdf.go_to_page pdf.page_count

					# Back page generation
					pdf.back_page
					
					# Outputs to file
					pdf.output
					
				end
			end
			
		
	end
	
end

end
