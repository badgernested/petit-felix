#!/usr/bin/env ruby
require "./felix"

### Entry point for program

felix = PetitFelix::Felix.new
felix.start(args: ARGV)
