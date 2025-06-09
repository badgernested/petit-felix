#!/usr/bin/env ruby
require "./source/pdfgen_basic"
require "./source/felix/config"

### Entry point for program

## Loads options from default values, ./default.cfg and CLI
config = Felix::Config.new
options = config.load_config ARGV

## Starts producing stuff
felix_basic = PdfFelixBasic::Generator.new
felix_basic.set_base_options(options)
felix_basic.render_all_files
