#!/usr/bin/env ruby
require "./source/felix/generator"
require "./source/felix/config"

### Entry point for program

## Loads options from default values, ./default.cfg and CLI
config = Felix::Config.new
options = config.load_config ARGV

## Starts producing stuff
felix_basic = Felix::Generator.new
felix_basic.render_files options
