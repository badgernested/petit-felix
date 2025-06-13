require "petit-felix"

module Jekyll

  class AuthorGenerator < Generator

	def generate(site)
	
	if !defined?(site.config["gen_pdf"])
		return
	else
		if !site.config["gen_pdf"]
			return
		end
	end

	site.posts.docs.each do |page|
		
		if defined?(page.pdf)
		
			options = {
				"input_files" => page.path,
				"image_dir" => ".",
				"author" => "punishedfelix.com",
				"author_back" => "punishedfelix.com",
				"back_cover_image" => "./images/article_pic/felixlogo.png",
				"output_dir" => "./pdf",
			}
			
			felix = PetitFelix::Output.new(options: options)
			
		end

	end
		
	end
end
end
