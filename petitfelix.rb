#!/usr/bin/env ruby
require "./source/pdfgen_basic"

felix_basic = PdfFelixBasic::Generator.new
felix_basic.render_all_files
