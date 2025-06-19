
module PetitFelix
	class FileManager
	
		def file_from_string string
			file_split = file_array_from_string string
			
			if file_split.count > 0
				string = File.join(file_split)
			end
			
			return string
		end
		
		def file_array_from_string string
			file_split = []
			
			if string.include? "/"
				file_split = string.split("/")
			elsif  string.include? "\\"
				file_split = string.split("\\")
			end
			
			return file_split
		end
	
	end
end
