## Helper class that handles metadata

module PetitFelix

	class	Metadata

		## Gets metadata from string into paired hashes
		def get_metadata(input)
			array = input.lines

			metadata = {}
			
			array.each do |set|
				if set.count(":") >= 1
					data = set.split(":")
					index = data[0].strip.downcase
					metadata[index] = data[1].strip
				end
			end
			metadata
		end
		
		## Splits files into array into metadata strings and content
		def split(input)
			input = input.split("---")
			if input.count > 1
				input = input.reject! { |s| s.nil? || s.empty? }
			end
			input
		end
		
	end
end
