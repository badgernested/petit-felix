require "prawn"
require 'fileutils'
require "prawndown-ext"
require "felix/metadata"
require "worker/pdf_writer"

## Prawn PDF writer that inputs template files

module PetitFelix
	module Worker

		class	TemplatePDFWriter < PetitFelix::Worker::DefaultPDFWriter
			
		end
	end
end
